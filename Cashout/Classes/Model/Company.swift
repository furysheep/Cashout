//
//	Company.swift

import Foundation

struct Company : Codable {

	let cF : String?
	let pIVA : String?
	let address : String?
	let city : String?
	let createdAt : String?
	let district : String?
	let email : String?
	let id : Int?
	let logoImg : String?
	let name : String?
	let phone : String?
	let updatedAt : String?
	let website : String?
	let zip : String?
   
    var completeAddress: String {
        return computeAddress()
    }

	enum CodingKeys: String, CodingKey {
		case cF = "CF"
		case pIVA = "PIVA"
		case address = "address"
		case city = "city"
		case createdAt = "created_at"
		case district = "district"
		case email = "email"
		case id = "id"
		case logoImg = "logo_img"
		case name = "name"
		case phone = "phone"
		case updatedAt = "updated_at"
		case website = "website"
		case zip = "zip"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		cF = try values.decodeIfPresent(String.self, forKey: .cF)
		pIVA = try values.decodeIfPresent(String.self, forKey: .pIVA)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		city = try values.decodeIfPresent(String.self, forKey: .city)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		district = try values.decodeIfPresent(String.self, forKey: .district)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		logoImg = try values.decodeIfPresent(String.self, forKey: .logoImg)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		website = try values.decodeIfPresent(String.self, forKey: .website)
		zip = try values.decodeIfPresent(String.self, forKey: .zip)
	}

    private func computeAddress() -> String {
        var addressToCompute:String = ""
        addressToCompute.append(contentsOf: (address! + ", "))
        addressToCompute.append(contentsOf: (city! + ", "))
        addressToCompute.append(contentsOf: (district! + " - " + zip!))
        return addressToCompute
    }
}
