//
//  UserManager.swift
//  Cashout
//


import Foundation
import Alamofire

class UserManager {
    private init () {}
    
    static let shared = UserManager()
    
    private var _user:User?
    
    var loggedInUser:User? {
        let _user = self._user ?? _fetchUserFromDefault()
        self._user = _user
        return self._user
    }
    
    private func _setUserInDefault (user:User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "user")
            defaults.synchronize()
        }
    }
    
    private func _fetchUserFromDefault() -> User? {
        let defaults = UserDefaults.standard
        if let savedUser = defaults.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode(User.self, from: savedUser) {
                return loadedUser
            }
        }
        return nil
    }
    
    private func _clearUserInDefault () {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "user")
        defaults.synchronize()
    }
    
    func resetUser() {
        self._user = nil
        self._clearUserInDefault()
    }
    
    func setUser(user: User) {
        self._user = user
        self._setUserInDefault(user: user)
    }
    
    func logout(completion: @escaping (Bool) -> Void) {
        Alamofire.request(URL.init(string: Constants.endpoint+"/logout")!, method: .post, parameters: [:],encoding: JSONEncoding.default, headers: ["Content-Type": "application/json", "Authorization":(""+TokenManager.shared.userToken!)]).responseJSON { (serverResponse) in
            if let responseCode = serverResponse.response?.statusCode {
                if (serverResponse.result.isSuccess) {
                    //            if let data = serverResponse.data {
                    //                print(String(bytes: data, encoding: .utf8))
                    //            }
                    UserManager.shared.resetUser()
                    TokenManager.shared.resetToken()
                    completion(true)
                    return;
                }
            }
            completion(false)
        }
    }
    
    func makePostCallWithAlamofire(email:String, password:String,completion: @escaping (Bool) -> Void) {
        Alamofire.request(URL.init(string: Constants.endpoint+"/login")!, method: .post, parameters: ["email":email,"password":password],encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON { [weak self] (serverResponse) in
            let responseCode = serverResponse.response?.statusCode
            if serverResponse.result.isSuccess, let data = serverResponse.data {
                SharedClass.shared.logMsg("---------------------------------------------------------------")
                // logMsg("Request......\n\(block.request)\nURL = \(completeUrl)")
                SharedClass.shared.logMsg("Response......\n" + (String.init(bytes: data, encoding: .utf8) ?? "-"))
                SharedClass.shared.logMsg("---------------------------------------------------------------")
                
                if responseCode == 401 {
                    // logout user
                    completion(false)
                } else {
                    do {
                        // Decode data to object
                        let jsonDecoder = JSONDecoder()
                        let user = try jsonDecoder.decode(User.self, from: data)
                        let headerToken = ("Bearer \(user.accessToken!)")
                        print("token : \(headerToken)")
                        TokenManager.shared.setToken(token: headerToken)
                        self!.setUser(user:user)
                        completion(true)
                    }
                    catch {
                        completion(false)
                    }
                }
                
            }
                //            if let value = response.result.value as? [String: Any] {
                //
                //                if let token:String = value["access_token"] as? String {
                //                    let headerToken = ("Bearer \(token)")
                //                    print("token : \(headerToken)")
                //                    //TokenManager.shared.setToken(token: headerToken)
                //                    guard let json = try? JSON(data: response.data!) else {
                //                        return
                //                    }
                //                    if let arr = json.dictionary {
                ////                        completion(arr,true)
                //                        let dict1 = (value["company"]) as! [String:Any]
                //                    let dict = (value["company"]) as! Dictionary<String,Any>
                //
                //                    let address = dict["address"] as? String ?? ""
                //                    let city = dict["city"] ?? ""
                //                    let district = dict["district"] ?? ""
                //                    let zip = dict["zip"] ?? ""
                //                    let completeAddress:String = "\(address), \(city), \(district) - \(zip)"
                //
                ////                    firstName: value["fname"] as! String, lastName: value["lname"] as! String, companyName: value["company"] as! String, address: completeAddress, phoneNo: value["phone"] as! String, email: value["email"] as! String, PIVA: value["PIVA"] as! String, CF: value["CF"] as! String, SID: "", customerId: value["fname"] as! String,agentCode:value["agent_code"] as! String)
                //
                //                    SharedClass.shared.currentUser = User.init(id: value["id"] as! String, firstName: value["fname"] as! String, lastName: value["lname"] as! String, companyName: value["company"] as! String, address: completeAddress, phoneNo: value["phone"] as! String, email: value["email"] as! String, PIVA: value["PIVA"] as! String, CF: value["CF"] as! String, SID: "", customerId: value["fname"] as! String,agentCode:value["agent_code"] as! String)
                //                    completion(true)
                //                    }
                //                }
                //                else {
                //                    completion(false)
                //                }
                //            }
            else {
                completion(false)
            }
        }
    }
}
