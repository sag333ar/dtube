//
//  ValidateHiveKeyResponse.swift
//  Runner
//
//  Created by Sagar on 02/05/22.
//

import Foundation

struct ValidateDTubeKeyResponse: Codable {
	let valid: Bool
	let username: String
	let key: String
	let error: String

	static func jsonStringFrom(dict: [String: AnyObject]) -> String? {
		guard
			let isValid = dict["valid"] as? Bool,
			let username = dict["username"] as? String,
			let key = dict["key"] as? String,
			let error = dict["error"] as? String
		else { return nil }
		let response = ValidateDTubeKeyResponse(
			valid: isValid,
			username: username,
			key: key,
			error: error
		)
		guard let data = try? JSONEncoder().encode(response) else { return nil }
		guard let dataString = String(data: data, encoding: .utf8) else { return nil }
		return dataString
	}
}
