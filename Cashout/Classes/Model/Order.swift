//
//  Order.swift
//  Cashout
//


import RealmSwift

class Order: Object {
    
    enum orderStatus: Int {
        case orderOpen = 1
        case orderComplete = 2
        case orderCancel = 3
    }
    
    @objc private(set) dynamic var id = ""
    @objc private(set) dynamic var number = ""
    @objc private(set) dynamic var status : Int = orderStatus.orderOpen.rawValue
    @objc private(set) dynamic var itemCount = 0
    @objc private(set) dynamic var amount:Float = 0.0
    @objc private(set) dynamic var amountPending:Float = 0.0
    
    let Items = List<Item>()
    let Transactions = List<Transaction>()

    
    var currentStatus: orderStatus {
        get { return orderStatus(rawValue: status)! }
        set { status = newValue.rawValue }
    }
    
    convenience init(id : String, number: String, status : orderStatus, itemCount : Int = 0, amount : Float, amountPending:Float) {
        self.init()
        self.id = id
        self.number = number
        self.status = status.rawValue
        self.itemCount = itemCount
        self.amount = amount
        self.amountPending = amountPending
    }
    
}
