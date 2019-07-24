//
//	TransactionResponseData.swift

import Foundation

struct TransactionResponseData : Codable {

	let exception : String?
	//let headers : Header?
	let original : Original?


//    enum CodingKeys: String, CodingKey {
//        case exception = "exception"
//        //case headers
//        case original = "original"
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        exception = try values.decodeIfPresent(String.self, forKey: .exception)
//        //headers = try Header(from: decoder)
//        original = try Original(from: decoder)
//    }


}
