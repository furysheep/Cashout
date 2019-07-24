//
//  TokenManager.swift
//  Cashout
//

import Foundation

class TokenManager {
    private init () {}
    
    static let shared = TokenManager()
    
    private var _token:String?
    
    var userToken:String? {
        let _token = self._token ?? _fetchTokenFromDefault()
        self._token = _token
        return self._token
    }
    
    private func _setTokenInDefault (token:String) {
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: "token")
        defaults.synchronize()
    }
    
    private func _fetchTokenFromDefault() -> String? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: "token") as? String
    }
    
    private func _clearTokenInDefault () {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "token")
        defaults.synchronize()
    }
    
    func resetToken() {
        self._token = nil
        self._clearTokenInDefault()
    }
    
    func setToken(token: String) {
        self._token = token
        self._setTokenInDefault(token: token)
    }
    

}
