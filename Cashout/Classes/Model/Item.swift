//
//  Item.swift
//  Cashout
//


import RealmSwift

class Item: Object {
    @objc private(set) dynamic var id = ""
    @objc private(set) dynamic var itemId = ""
    @objc private(set) dynamic var name = ""
    @objc private(set) dynamic var itemDescription = ""
    @objc private(set) dynamic var price:Float = 0.0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id : String, itemId: String, name : String, itemDescription : String, price : Float) {
        self.init()
        self.id = id
        self.itemId = itemId
        self.name = name
        self.itemDescription = itemDescription
        self.price = price
    }
    
}
