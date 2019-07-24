//
//  ModelManager.swift
//  Cashout
//


import UIKit

class ModelManager: NSObject {
    
    static let shared: ModelManager = {
        let instance = ModelManager()
        return instance
    }()
    
    private override init(){
        
    }
}
