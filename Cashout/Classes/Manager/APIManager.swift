//
//  APIManager.swift
//  Cashout
//


import Alamofire
import SwiftyJSON

class APIManager {
    
    //Shared Instance
    static let shared = APIManager()
    
    private init() {}
    
    func getCustomersList(completion: @escaping ([JSON]?) -> Void) {
        let todoEndpoint: String = "https://www.cashout.credit/api/customers"
        Alamofire.request(URL.init(string: todoEndpoint)!, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: ["Content-Type": "application/json", "Authorization":(""+TokenManager.shared.userToken!)]).responseJSON { serverResponse in
            
            let responseCode = serverResponse.response?.statusCode
            if serverResponse.result.isSuccess, let data = serverResponse.data {
                SharedClass.shared.logMsg("---------------------------------------------------------------")
                //logMsg("Request......\n\(block.request)\nURL = \(completeUrl)")
                SharedClass.shared.logMsg("Response......\n" + (String.init(bytes: data, encoding: .utf8) ?? "-"))
                SharedClass.shared.logMsg("---------------------------------------------------------------")
                if responseCode == 401 {
                    // logout user
                }
                
                guard let json = try? JSON(data: data) else {
                    completion(nil)
                    return
                }
                
                if let arr:[JSON] = json.arrayValue {
                    completion(arr)
                }
                else {
                    completion(nil)
                }
                
            }
            else {
                completion(nil)
            }
        }
    }
    
    
    func makeGetCallWithAlamofireCustomerOrders(id: String, completion: @escaping ([JSON]?,Bool) -> Void) {
        let todoEndpoint: String = "https://www.cashout.credit/api/customerorders"
        Alamofire.request(URL.init(string: todoEndpoint)!, method: .post, parameters: ["id":id],encoding: JSONEncoding.default, headers: ["Content-Type": "application/json", "Authorization":(""+TokenManager.shared.userToken!)]).responseJSON { serverResponse in
            
            let responseCode = serverResponse.response?.statusCode
            if serverResponse.result.isSuccess, let data = serverResponse.data {
                SharedClass.shared.logMsg("---------------------------------------------------------------")
                //logMsg("Request......\n\(block.request)\nURL = \(completeUrl)")
                SharedClass.shared.logMsg("Response......\n" + (String.init(bytes: data, encoding: .utf8) ?? "-"))
                SharedClass.shared.logMsg("---------------------------------------------------------------")
                if responseCode == 401 {
                    // logout user
                }
                
                guard let json = try? JSON(data: data) else {
                    completion(nil,false)
                    return
                }
                
                if let arr:[JSON] = json.arrayValue {
                    completion(arr,true)
                }
                else {
                    completion(nil,false)
                }
                
            }
            else {
                completion(nil,false)
            }
        }
        
    }
    
    
    func makeGetCallWithAlamofireOrder(id: String, completion: @escaping ([JSON]?,Bool) -> Void) {
        let todoEndpoint: String = "https://www.cashout.credit/api/order"
        Alamofire.request(URL.init(string: todoEndpoint)!, method: .post, parameters: ["id":id],encoding: JSONEncoding.default, headers: ["Content-Type": "application/json", "Authorization":(""+TokenManager.shared.userToken!)]).responseJSON { serverResponse in
            
            let responseCode = serverResponse.response?.statusCode
            if serverResponse.result.isSuccess, let data = serverResponse.data {
                SharedClass.shared.logMsg("---------------------------------------------------------------")
                //logMsg("Request......\n\(block.request)\nURL = \(completeUrl)")
                SharedClass.shared.logMsg("Response......\n" + (String.init(bytes: data, encoding: .utf8) ?? "-"))
                SharedClass.shared.logMsg("---------------------------------------------------------------")
                if responseCode == 401 {
                    // logout user
                }
                guard let json = try? JSON(data: data) else {
                    completion(nil,false)
                    return
                }
                
                if let arr:[JSON] = json.arrayValue {
                    completion(arr,true)
                }
                else {
                    completion(nil,false)
                }
                
            }
            else {
                completion(nil,false)
                return
            }
        }
    }
    
    //    "id":String, #Order id
    //    "status":Int, #1 = completed, 2 = cancelled
    //    "complete":Bool, #true only for status 1
    func updateOrderStatusWith(id: String, status:Int,complete:Bool,completion: @escaping (UpdateOrderResponse?,Bool) -> Void) {
        Alamofire.request(URL.init(string: Constants.endpoint+"/updateorderstatus")!, method: .post, parameters: ["id":id,"status":status,"complete":complete]
            ,encoding: JSONEncoding.default, headers: ["Content-Type": "application/json", "Authorization":(""+TokenManager.shared.userToken!)]).responseJSON { (serverResponse) in
                
                let responseCode = serverResponse.response?.statusCode
                if serverResponse.result.isSuccess, let data = serverResponse.data {
                    SharedClass.shared.logMsg("---------------------------------------------------------------")
                    //logMsg("Request......\n\(block.request)\nURL = \(completeUrl)")
                    SharedClass.shared.logMsg("Response......\n" + (String.init(bytes: data, encoding: .utf8) ?? "-"))
                    SharedClass.shared.logMsg("---------------------------------------------------------------")
                    if responseCode == 401 {
                        // logout user
                    }
                    do {
                        // Decode data to object
                        let jsonDecoder = JSONDecoder()
                        let updateOrderResponse = try jsonDecoder.decode(UpdateOrderResponse.self, from: data)
                        completion(updateOrderResponse,true)
                    }
                    catch {
                        completion(nil,false)
                    }
                }
                else {
                    completion(nil,false)
                    return
                }
        }
    }
    
    func makeTransactionWith(orderId:String, kind:String, payment:String,bank:String, checkNumber:String,price:String,completion: @escaping (TransactionResponseData?,Bool) -> Void) {
        
        //        {
        //            "order_id": "351f8490-5c21-11e9-9b45-0f65e3249fbf",
        //            "kind":"advance",
        //            "payment":"cash",
        //            "bank":"Bank Of America",
        //            "check_number":"12367",
        //            "storno_doc":"A1-34",
        //            "price":13
        //        }
        let prc = price.replacingOccurrences(of: ",", with: "")
        Alamofire.request(URL.init(string: Constants.endpoint+"/transaction/make")!, method: .post, parameters: ["order_id":orderId,"kind":kind,"payment":payment,"bank":bank,"check_number":checkNumber,"price":prc],encoding: JSONEncoding.default, headers: ["Content-Type": "application/json", "Authorization":(""+TokenManager.shared.userToken!)]).responseJSON { (serverResponse) in
            
            let responseCode = serverResponse.response?.statusCode
            if serverResponse.result.isSuccess, let data = serverResponse.data {
                SharedClass.shared.logMsg("---------------------------------------------------------------")
                //logMsg("Request......\n\(block.request)\nURL = \(completeUrl)")
                SharedClass.shared.logMsg("Response......\n" + (String.init(bytes: data, encoding: .utf8) ?? "-"))
                SharedClass.shared.logMsg("---------------------------------------------------------------")
                if responseCode == 401 {
                    // logout user
                }
                do {
                    // Decode data to object
                    let jsonDecoder = JSONDecoder()
                    let transactionResponse = try jsonDecoder.decode(TransactionResponseData.self, from: data)
                    completion(transactionResponse,true)
                }
                catch {
                    completion(nil,false)
                }
            }
            else {
                completion(nil,false)
                return
            }
        }
    }
    
    
}
