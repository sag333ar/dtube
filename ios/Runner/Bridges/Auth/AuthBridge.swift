//
//  AuthBridge.swift
//  Runner
//
//  Created by Sagar on 01/05/22.
//

import UIKit
import Flutter

class AuthBridge {
	var window: UIWindow?
	var dtube: DTubeWebViewController?

	func initiate(controller: FlutterViewController, window: UIWindow?, dtube: DTubeWebViewController?) {
		self.window = window
		self.dtube = dtube
		let authChannel = FlutterMethodChannel(
			name: "com.sagar.dtube/auth",
			binaryMessenger: controller.binaryMessenger
		)
		authChannel.setMethodCallHandler({
			[weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
			// Note: this method is invoked on the UI thread.
			guard
				call.method == "validate",
				let arguments = call.arguments as? NSDictionary,
				let username = arguments ["username"] as? String,
				let password = arguments["key"] as? String
			else {
				result(FlutterMethodNotImplemented)
				return
			}
			self?.authenticate(username: username, key: password, result: result)
		})
	}

	private func authenticate(username: String, key: String, result: @escaping FlutterResult) {
		guard let dtube = dtube else {
			result(FlutterError(code: "ERROR",
													message: "Error setting up Hive",
													details: nil))
			return
		}
		dtube.validatePostingKey(username: username, key: key) { response in
			result(response)
		}
	}
}
