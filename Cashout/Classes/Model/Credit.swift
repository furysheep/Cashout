//
//  Credit.swift
//  Cashout
//
//  Created by Mistake on 8/11/19.
//  Copyright © 2019 gymia. All rights reserved.
//

import RealmSwift

class Credit: NSObject {
    @objc private(set) dynamic var storno_id: Int64 = 0
    @objc private(set) dynamic var n_doc = ""
    @objc private(set) dynamic var name_doc = ""
    @objc private(set) dynamic var date_doc = ""
    @objc private(set) dynamic var date_doc_ita = ""
    @objc private(set) dynamic var avere:Float = 0.0
    
    convenience init(storno_id: Int64, n_doc: String, name_doc: String, date_doc: String, date_doc_ita: String, avere: Float) {
        self.init()
        self.storno_id = storno_id
        self.n_doc = n_doc
        self.name_doc = name_doc
        self.date_doc = date_doc
        self.date_doc_ita = date_doc_ita
        self.avere = avere
    }
}
