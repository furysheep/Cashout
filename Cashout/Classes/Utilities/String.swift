//
//  String.swift
//  Cashout
//


import Foundation

//All the user visible strings have been kept in this file, using an extension of String class
extension String {
    
    func trimSpace() -> String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: " "))
    }
    
    static let strAlert = "Alert".localized()
    //    static let strFailed = "Failed"
    static let strOk = "OK".localized()
    //    static let strNoInternet = "Please check your internet connection"
    
    // MARK: -----------Validation strings----------
    struct LoginErrorMessages {
        static let strBlankEmail = "Email cannot be blank".localized()
        static let strInvalidEmail = "Enter a valid email address [Eg:abc@yahoo.com]".localized()
        static let strEmptyPassword = "Please enter password".localized()
        
    }
    static let strTransactionEmpty = "Transaction Amount Cannot be Blank".localized()
    static let strBankEmpty = "Bank Name Cannot be Blank".localized()
    static let strCheckNoEmpty = "Check No Cannot be Blank".localized()
    
    
    
    //    struct LogoutMessages {
    //        static let strLogoutAlert = "Are you sure you want to logout?"
    //    }
}

