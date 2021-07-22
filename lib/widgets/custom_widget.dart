part of '../google_maps_pro.dart';

class _AddressAutoComplete<T extends Object> extends StatefulWidget {
  /// Create an instance of _AddressAutoComplete.
  ///
  /// [displayStringForOption], [optionsBuilder] and [optionsViewBuilder] must
  /// not be null.
  const _AddressAutoComplete({
    Key? key,
    required this.optionsBuilder,
    required this.optionsViewBuilder,
    this.fieldViewBuilder,
    this.focusNode,
    this.onSelected,
    this.textEditingController,
    this.displayStringForOption = defaultStringForOption,
    required this.context,
  })  : assert(
          fieldViewBuilder != null ||
              (key != null &&
                  focusNode != null &&
                  textEditingController != null),
          'Pass in a fieldViewBuilder, or otherwise create a separate field and pass in the FocusNode, TextEditingController, and a key. Use the key with _AddressAutoComplete.onFieldSubmitted.',
        ),
        assert((focusNode == null) == (textEditingController == null)),
        super(key: key);

  /// {@template google_maps_pro.widgets._AddressAutoComplete.fieldViewBuilder}
  /// Builds the field whose input is used to get the options.
  ///
  /// Pass the provided [TextEditingController] to the field built here so that
  /// _AddressAutoComplete can listen for changes.
  /// {@endtemplate}
  final AutocompleteFieldViewBuilder? fieldViewBuilder;

  /// The [FocusNode] that is used for the text field.
  ///
  /// {@template google_maps_pro.widgets._AddressAutoComplete.split}
  /// The main purpose of this parameter is to allow the use of a separate text
  /// field located in another part of the widget tree instead of the text
  /// field built by [fieldViewBuilder]. For example, it may be desirable to
  /// place the text field in the AppBar and the options below in the main body.
  ///
  /// When following this pattern, [fieldViewBuilder] can return
  /// `SizedBox.shrink()` so that nothing is drawn where the text field would
  /// normally be. A separate text field can be created elsewhere, and a
  /// FocusNode and TextEditingController can be passed both to that text field
  /// and to _AddressAutoComplete.
  ///
  /// If this parameter is not null, then [textEditingController] must also be
  /// not null.
  final FocusNode? focusNode;

  /// {@template google_maps_pro.widgets._AddressAutoComplete.optionsViewBuilder}
  /// Builds the selectable options widgets from a list of options objects.
  ///
  /// The options are displayed floating below the field using a
  /// [CompositedTransformFollower] inside of an [Overlay], not at the same
  /// place in the widget tree as [_AddressAutoComplete].
  /// {@endtemplate}
  final AutocompleteOptionsViewBuilder<T> optionsViewBuilder;

  /// {@template google_maps_pro.widgets._AddressAutoComplete.displayStringForOption}
  /// Returns the string to display in the field when the option is selected.
  ///
  /// This is useful when using a custom T type and the string to display is
  /// different than the string to search by.
  ///
  /// If not provided, will use `option.toString()`.
  /// {@endtemplate}
  final AutocompleteOptionToString<T> displayStringForOption;

  /// {@template google_maps_pro.widgets._AddressAutoComplete.onSelected}
  /// Called when an option is selected by the user.
  ///
  /// Any [TextEditingController] listeners will not be called when the user
  /// selects an option, even though the field will update with the selected
  /// value, so use this to be informed of selection.
  /// {@endtemplate}
  final AutocompleteOnSelected<T>? onSelected;

  /// {@template google_maps_pro.widgets._AddressAutoComplete.optionsBuilder}
  /// A function that returns the current selectable options objects given the
  /// current TextEditingValue.
  /// {@endtemplate}
  final AutocompleteOptionsBuilder<T> optionsBuilder;

  /// The [TextEditingController] that is used for the text field.
  ///
  /// {@macro google_maps_pro.widgets._AddressAutoComplete.split}
  ///
  /// If this parameter is not null, then [focusNode] must also be not null.
  final TextEditingController? textEditingController;

  ///
  ///
  final BuildContext context;

  /// Calls [AutocompleteFieldViewBuilder]'s onFieldSubmitted callback for the
  /// _AddressAutoComplete widget indicated by the given [GlobalKey].
  ///
  /// This is not typically used unless a custom field is implemented instead of
  /// using [fieldViewBuilder]. In the typical case, the onFieldSubmitted
  /// callback is passed via the [AutocompleteFieldViewBuilder] signature. When
  /// not using fieldViewBuilder, the same callback can be called by using this
  /// static method.
  ///
  /// See also:
  ///
  ///  * [focusNode] and [textEditingController], which contain a code example
  ///    showing how to create a separate field outside of fieldViewBuilder.
  static void onFieldSubmitted<T extends Object>(GlobalKey key) {
    final _AddressAutoCompleteState<T> _addressAutoComplete =
        key.currentState! as _AddressAutoCompleteState<T>;
    _addressAutoComplete._onFieldSubmitted();
  }

  /// The default way to convert an option to a string in
  /// [displayStringForOption].
  ///
  /// Simply uses the `toString` method on the option.
  static String defaultStringForOption(dynamic option) {
    return option.toString();
  }

  @override
  _AddressAutoCompleteState<T> createState() => _AddressAutoCompleteState<T>();
}

class _AddressAutoCompleteState<T extends Object>
    extends State<_AddressAutoComplete<T>> {
  final GlobalKey _fieldKey = GlobalKey();
  final LayerLink _optionsLayerLink = LayerLink();
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;
  Iterable<T> _options = Iterable<T>.empty();
  T? _selection;

  // The OverlayEntry containing the options.
  OverlayEntry? _floatingOptions;

  // True iff the state indicates that the options should be visible.
  bool get _shouldShowOptions {
    return _focusNode.hasFocus && _selection == null && _options.isNotEmpty;
  }

  // Called when _textEditingController changes.
  void _onChangedField() {
    final Iterable<T> options = widget.optionsBuilder(
      _textEditingController.value,
    );
    _options = options;
    if (_selection != null &&
        _textEditingController.text !=
            widget.displayStringForOption(_selection!)) {
      _selection = null;
    }
    _updateOverlay();
  }

  // Called when the field's FocusNode changes.
  void _onChangedFocus() {
    _updateOverlay();
  }

  // Called from fieldViewBuilder when the user submits the field.
  void _onFieldSubmitted() {
    if (_options.isEmpty) {
      return;
    }
    _select(_options.first);
  }

  // Select the given option and update the widget.
  void _select(T nextSelection) {
    if (nextSelection == _selection) {
      return;
    }
    _selection = nextSelection;
    final String selectionString = widget.displayStringForOption(nextSelection);
    _textEditingController.value = TextEditingValue(
      selection: TextSelection.collapsed(offset: selectionString.length),
      text: selectionString,
    );
    widget.onSelected?.call(_selection!);
  }

  // Hide or show the options overlay, if needed.
  void _updateOverlay() {
    if (_shouldShowOptions) {
      _floatingOptions?.remove();
      _floatingOptions = OverlayEntry(
        builder: (BuildContext context) {
          RenderBox? renderBox =
              widget.context.findRenderObject() as RenderBox?;
          var widgetSize = renderBox!.size;
          return CompositedTransformFollower(
            link: _optionsLayerLink,
            offset: setPosition(renderBox, _options.length),
            targetAnchor: Alignment.topLeft,
            followerAnchor: Alignment.topLeft,
            showWhenUnlinked: false,
            child: CustomSingleChildLayout(
                delegate: _MyDelegate(widgetSize),
                child: widget.optionsViewBuilder(context, _select, _options)),
          );
        },
      );
      Overlay.of(widget.context, rootOverlay: true)!.insert(_floatingOptions!);
    } else if (_floatingOptions != null) {
      _floatingOptions!.remove();
      _floatingOptions = null;
    }
  }

  // Handle a potential change in textEditingController by properly disposing of
  // the old one and setting up the new one, if needed.
  void _updateTextEditingController(
      TextEditingController? old, TextEditingController? current) {
    if ((old == null && current == null) || old == current) {
      return;
    }
    if (old == null) {
      _textEditingController.removeListener(_onChangedField);
      _textEditingController.dispose();
      _textEditingController = current!;
    } else if (current == null) {
      _textEditingController.removeListener(_onChangedField);
      _textEditingController = TextEditingController();
    } else {
      _textEditingController.removeListener(_onChangedField);
      _textEditingController = current;
    }
    _textEditingController.addListener(_onChangedField);
  }

  // Handle a potential change in focusNode by properly disposing of the old one
  // and setting up the new one, if needed.
  void _updateFocusNode(FocusNode? old, FocusNode? current) {
    if ((old == null && current == null) || old == current) {
      return;
    }
    if (old == null) {
      _focusNode.removeListener(_onChangedFocus);
      _focusNode.dispose();
      _focusNode = current!;
    } else if (current == null) {
      _focusNode.removeListener(_onChangedFocus);
      _focusNode = FocusNode();
    } else {
      _focusNode.removeListener(_onChangedFocus);
      _focusNode = current;
    }
    _focusNode.addListener(_onChangedFocus);
  }

  @override
  void initState() {
    super.initState();
    _textEditingController =
        widget.textEditingController ?? TextEditingController();
    _textEditingController.addListener(_onChangedField);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onChangedFocus);
    SchedulerBinding.instance!.addPostFrameCallback((Duration _) {
      _updateOverlay();
    });
  }

  @override
  void didUpdateWidget(_AddressAutoComplete<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateTextEditingController(
      oldWidget.textEditingController,
      widget.textEditingController,
    );
    _updateFocusNode(oldWidget.focusNode, widget.focusNode);
    SchedulerBinding.instance!.addPostFrameCallback((Duration _) {
      _updateOverlay();
    });
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_onChangedField);
    if (widget.textEditingController == null) {
      _textEditingController.dispose();
    }
    _focusNode.removeListener(_onChangedFocus);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _floatingOptions?.remove();
    _floatingOptions = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _fieldKey,
      child: CompositedTransformTarget(
        link: _optionsLayerLink,
        child: widget.fieldViewBuilder == null
            ? const SizedBox.shrink()
            : widget.fieldViewBuilder!(
                context,
                _textEditingController,
                _focusNode,
                _onFieldSubmitted,
              ),
      ),
    );
  }

  Offset setPosition(RenderBox? renderBox, int listLength) {
    var widgetSize = renderBox!.size;
    var screenSize = MediaQuery.of(context).size;
    var widgetCurrentPosition = renderBox.localToGlobal(Offset.zero);
    Offset position = Offset(
        0,
        (widgetCurrentPosition.dy + kToolbarHeight) >= screenSize.width
            ? -((listLength + 1) * widgetSize.height) - 38
            : 8.0);
    print('size :: $widgetSize');
    print('widgetCurrentPosition :: $widgetCurrentPosition');
    print('screenSize :: $screenSize');
    print('position :: ${position.dy}');
    print('listLength :: ${kToolbarHeight / listLength}');
    return position;
  }
}

class _MyDelegate extends SingleChildLayoutDelegate {
  final Size anchorSize;

  _MyDelegate(this.anchorSize);

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraints.loosen();
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    print("my size: $size");
    print("childSize: $childSize");
    print("anchor size being passed in: $anchorSize");
    print("anchor size being passed in: $anchorSize");
    return Offset(0, kToolbarHeight);
  }

  @override
  bool shouldRelayout(_) => true;
}

// The default Material-style Autocomplete text field.
class _AutocompleteField extends StatelessWidget {
  const _AutocompleteField({
    Key? key,
    required this.focusNode,
    required this.textEditingController,
    required this.onFieldSubmitted,
    this.inputDecoration,
  }) : super(key: key);

  final FocusNode focusNode;

  final VoidCallback onFieldSubmitted;

  final TextEditingController textEditingController;

  final InputDecoration? inputDecoration;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      focusNode: focusNode,
      decoration: inputDecoration ??
          InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              labelText: 'Search address'),
      onFieldSubmitted: (String value) {
        onFieldSubmitted();
      },
    );
  }
}

// The default Material-style Autocomplete options.
class _AutocompleteOptions<T extends Object> extends StatelessWidget {
  const _AutocompleteOptions({
    Key? key,
    required this.displayStringForOption,
    required this.onSelected,
    required this.options,
    required this.disableLogo,
  }) : super(key: key);

  final AutocompleteOptionToString<T> displayStringForOption;

  final AutocompleteOnSelected<T> onSelected;

  final Iterable<T> options;

  final bool disableLogo;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final T option = options.elementAt(index);
              return ListTile(
                onTap: () => onSelected(option),
                dense: true,
                title: Text(displayStringForOption(option)),
              );
            },
          ),
          Visibility(
            visible: !disableLogo,
            child: Column(
              children: [
                SizedBox(
                  height: 8.0,
                ),
                Image.asset(
                  'assets/google_logo.png',
                  package: 'google_maps_pro',
                  height: 30.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
