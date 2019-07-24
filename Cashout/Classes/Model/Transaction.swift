//
//  Transaction.swift
//  Cashout
//

import RealmSwift

class Transaction: Object {
    @objc private(set) dynamic var transactionId = ""
    @objc private(set) dynamic var number = ""
    @objc private(set) dynamic var bank = ""
    @objc private(set) dynamic var chequeNo = ""
    @objc private(set) dynamic var transactionDate = ""
    @objc private(set) dynamic var transactionType = ""
    @objc private(set) dynamic var price:Float = 0.00
    
    convenience init(transactionId : String, number : String, transactionDate : String, price : Float, transactionType:String,chequeNo:String,bank:String) {
        self.init()
        self.transactionId = transactionId
        self.number = number
        self.transactionDate = transactionDate
        self.price = price
        self.transactionType = transactionType
        self.chequeNo = chequeNo
        self.bank = bank
    }
    
}
