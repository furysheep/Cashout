//
//  Customer.swift
//  Cashout
//


//import UIKit
import  RealmSwift

class Customer: Object {
    @objc private(set) dynamic var id = ""
    @objc private(set) dynamic var firstName = ""
    @objc private(set) dynamic var lastName = ""
    @objc private(set) dynamic var companyName = ""
    @objc private(set) dynamic var  address = ""
    @objc private(set) dynamic var phoneNo = ""
    @objc private(set) dynamic var email = ""
    @objc private(set) dynamic var  PIVA = ""
    @objc private(set) dynamic var  CF = ""
    @objc private(set) dynamic var  SID = ""
    @objc private(set) dynamic var customerId = ""
    
    let orders = List<Order>()
    //    var gender = RealmOptional<Int>(0)
    //    var age = RealmOptional<Int>(0)
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id : String, firstName: String, lastName : String, companyName : String, address : String, phoneNo : String, email : String, PIVA : String, CF : String, SID : String, customerId : String) {
        self.init()
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.companyName = companyName
        self.address = address
        self.phoneNo = phoneNo
        self.email = email
        self.PIVA = PIVA
        self.CF = CF
        self.SID = SID
        self.customerId = customerId
    }
    
}

