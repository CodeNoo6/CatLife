import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyDBSLtAFqzfVi3X65FDL_9xI9E29a5ZSRs")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    @available(iOS 9.0, *)
      override func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
          let controller = window.rootViewController as? FlutterViewController
          
          let channel = FlutterMethodChannel(name: "plugins.flutter.io/quick_actions", binaryMessenger: controller! as! FlutterBinaryMessenger)
          channel.invokeMethod("launch", arguments: shortcutItem.type)
      }
}
