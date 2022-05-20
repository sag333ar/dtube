//
//  TransactBridge.swift
//  Runner
//
//  Created by Sagar on 20/05/22.
//

import Foundation
import UIKit
import Flutter

class TransactBridge {
	var window: UIWindow?
	var dtube: DTubeWebViewController?

	func initiate(controller: FlutterViewController, window: UIWindow?, dtube: DTubeWebViewController?) {
		self.window = window
		self.dtube = dtube
		let authChannel = FlutterMethodChannel(
			name: "com.sagar.dtube/transact",
			binaryMessenger: controller.binaryMessenger
		)
		authChannel.setMethodCallHandler({
			[weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
			// Note: this method is invoked on the UI thread.
			guard
				call.method == "perform",
				let arguments = call.arguments as? NSDictionary,
				let username = arguments ["username"] as? String,
				let password = arguments["key"] as? String,
				let data = arguments["data"] as? String,
				let type = arguments["type"] as? String
			else {
				result(FlutterMethodNotImplemented)
				return
			}
			self?.transact(username: username, key: password, data: data, type: type, result: result)
		})
	}

	private func transact(username: String, key: String, data: String, type: String, result: @escaping FlutterResult) {
		guard let dtube = dtube else {
			result(FlutterError(code: "ERROR",
													message: "Error setting up DTube",
													details: nil))
			return
		}
		dtube.transact(username: username, key: key, type: type, data: data) { responseString in
			result(responseString)
		}
	}
}
