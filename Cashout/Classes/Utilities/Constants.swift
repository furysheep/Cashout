//
//  Constants.swift
//  Cashout
//


import Foundation
import SVProgressHUD

class Constants {
    
    static let endpoint = "https://www.cashout.credit/api"
    enum OrderStatus:Int {
        case orderOpen
        case orderComplete
        case orderCancelled
    }
    
    // MARK: --------Storyboards----------
    struct StoryBoard {
        static let loginSB = "Login"
        static let homeSB = "Home"
        static let printSB = "Print"
        static let homeIpadSB = "Home_iPad"
    }
    
    // MARK: --------View Controller Storyboard Identifier----------
    struct ViewControllerIdentifier {
        static let loginViewController = "LoginVC"
        static let customerListViewController = "CustomerListVC"
        static let customerViewController = "CustomerVC"
        static let orderDetailsViewController = "OrderDetailsVC"
        static let orderStatusViewController = "OrderStatusVC"
        static let transactionViewController = "TransactionVC"
        static let printViewController = "PrintVC"
    }
    
    struct TableViewCellIdentifier {
        static let customerTableViewCellIdentifier = "CustomerTableViewCell"
        static let orderTableViewCellIdentifier = "OrderTableViewCell"
        static let articlesTableViewCellIdentifier = "ArticlesTableViewCell"
         static let printTableViewCellIdentifier = "PrintTableViewCell"
    }
    
    // MARK:  Validations
    
    //Email Validation
    static func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return (emailTest.evaluate(with: email))
    }
    
    //Password Validation
    static func isValidPassword(password:String) -> Bool {
        return password.count>0
    }
    
    // MARK: - Alert method
    static func showAlert(message:String)->Void    {
        let alert = UIAlertController(title: String.strAlert, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String.strOk, style: .default) { action in
            // perhaps use action.title here
        })
        let navigationController = UIApplication.shared.windows[0].rootViewController as! UINavigationController
        navigationController.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Loader method
    static func isLoaderVisible ()->Bool {
        return SVProgressHUD.isVisible()
    }
    static func showLoader () {
        if !SVProgressHUD.isVisible() {
            SVProgressHUD.show()
        }
    }
    
    static func hideLoader () {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
    }
    
    static func getTransactionType(type:String)->String {
        if type.lowercased() == "check" {
            return "Check".localized()
        }
        else {
            return "Cash".localized()
        }
    }
    
    
}
