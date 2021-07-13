#import "GoogleMapsProPlugin.h"
#if __has_include(<google_maps_pro/google_maps_pro-Swift.h>)
#import <google_maps_pro/google_maps_pro-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "google_maps_pro-Swift.h"
#endif

@implementation GoogleMapsProPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGoogleMapsProPlugin registerWithRegistrar:registrar];
}
@end
