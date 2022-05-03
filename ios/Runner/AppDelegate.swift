import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
	var dtube: DTubeWebViewController?
	let authBridge = AuthBridge()

	override func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		dtube = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DTubeWebViewController") as? DTubeWebViewController
		dtube?.viewDidLoad()

		let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
		authBridge.initiate(controller: controller, window: window, dtube: dtube)

		GeneratedPluginRegistrant.register(with: self)
		return super.application(application, didFinishLaunchingWithOptions: launchOptions)
	}
}
