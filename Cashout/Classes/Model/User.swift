//
//	User.swift

import Foundation

struct User : Codable {

	let accessToken : String?
	let agentCode : String?
	let company : [Company]?
	let expiresAt : String?
	let tokenType : String?


	enum CodingKeys: String, CodingKey {
		case accessToken = "access_token"
		case agentCode = "agent_code"
		case company = "company"
		case expiresAt = "expires_at"
		case tokenType = "token_type"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken)
		agentCode = try values.decodeIfPresent(String.self, forKey: .agentCode)
		company = try values.decodeIfPresent([Company].self, forKey: .company)
		expiresAt = try values.decodeIfPresent(String.self, forKey: .expiresAt)
		tokenType = try values.decodeIfPresent(String.self, forKey: .tokenType)
	}

}
