//
//	UpdateOrderResponse.swift
//

import Foundation

struct UpdateOrderResponse : Codable {

	let cF : String?
	let pIVA : String?
	let sDI : String?
	let address : String?
	let branchId : Int?
	let city : String?
	let company : String?
	let createdAt : String?
	let discount : Int?
	let district : String?
	let email : String?
	let id : String?
	let number : String?
	let orderId : String?
	let orderNumber : String?
	let phone : String?
	let price : Int?
	let printed : Int?
	let tax : Int?
	let total : Int?
	let transactionId : String?
	let updatedAt : String?
	let userId : Int?
	let zip : String?


	enum CodingKeys: String, CodingKey {
		case cF = "CF"
		case pIVA = "PIVA"
		case sDI = "SDI"
		case address = "address"
		case branchId = "branch_id"
		case city = "city"
		case company = "company"
		case createdAt = "created_at"
		case discount = "discount"
		case district = "district"
		case email = "email"
		case id = "id"
		case number = "number"
		case orderId = "order_id"
		case orderNumber = "order_number"
		case phone = "phone"
		case price = "price"
		case printed = "printed"
		case tax = "tax"
		case total = "total"
		case transactionId = "transaction_id"
		case updatedAt = "updated_at"
		case userId = "user_id"
		case zip = "zip"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		cF = try values.decodeIfPresent(String.self, forKey: .cF)
		pIVA = try values.decodeIfPresent(String.self, forKey: .pIVA)
		sDI = try values.decodeIfPresent(String.self, forKey: .sDI)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		branchId = try values.decodeIfPresent(Int.self, forKey: .branchId)
		city = try values.decodeIfPresent(String.self, forKey: .city)
		company = try values.decodeIfPresent(String.self, forKey: .company)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		discount = try values.decodeIfPresent(Int.self, forKey: .discount)
		district = try values.decodeIfPresent(String.self, forKey: .district)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		number = try values.decodeIfPresent(String.self, forKey: .number)
		orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
		orderNumber = try values.decodeIfPresent(String.self, forKey: .orderNumber)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		price = try values.decodeIfPresent(Int.self, forKey: .price)
		printed = try values.decodeIfPresent(Int.self, forKey: .printed)
		tax = try values.decodeIfPresent(Int.self, forKey: .tax)
		total = try values.decodeIfPresent(Int.self, forKey: .total)
		transactionId = try values.decodeIfPresent(String.self, forKey: .transactionId)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		userId = try values.decodeIfPresent(Int.self, forKey: .userId)
		zip = try values.decodeIfPresent(String.self, forKey: .zip)
	}


}
