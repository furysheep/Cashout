//
//	Original.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Original : Codable {
    
    let bank : String?
    let checkNumber : String?
    let closed : Int?
    let createdAt : String?
    let id : String?
    let kind : String?
    let number : String?
    let orderId : String?
    let payment : String?
    let paymentWord : String?
    let price : Float?
    let statusWord : String?
    let stornoDoc : String?
    let updatedAt : String?
    let userId : Int?
    
    
    enum CodingKeys: String, CodingKey {
        case bank = "bank"
        case checkNumber = "check_number"
        case closed = "closed"
        case createdAt = "created_at"
        case id = "id"
        case kind = "kind"
        case number = "number"
        case orderId = "order_id"
        case payment = "payment"
        case paymentWord = "payment_word"
        case price = "price"
        case statusWord = "status_word"
        case stornoDoc = "storno_doc"
        case updatedAt = "updated_at"
        case userId = "user_id"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bank = try values.decodeIfPresent(String.self, forKey: .bank)
        checkNumber = try values.decodeIfPresent(String.self, forKey: .checkNumber)
        closed = try values.decodeIfPresent(Int.self, forKey: .closed)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        kind = try values.decodeIfPresent(String.self, forKey: .kind)
        number = try values.decodeIfPresent(String.self, forKey: .number)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        payment = try values.decodeIfPresent(String.self, forKey: .payment)
        paymentWord = try values.decodeIfPresent(String.self, forKey: .paymentWord)
        price = try values.decodeIfPresent(Float.self, forKey: .price)
        statusWord = try values.decodeIfPresent(String.self, forKey: .statusWord)
        stornoDoc = try values.decodeIfPresent(String.self, forKey: .stornoDoc)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
    }
}
