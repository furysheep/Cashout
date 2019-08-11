//
//  TransactionViewController.swift
//  Cashout
//

import UIKit

class TransactionViewController: BaseViewController, UITextFieldDelegate, CreditPickerViewControllerDelegate {
    
    @IBOutlet weak var lblPaymentMethod: UILabel!
    private var strPaymentMethod:String = ""
    @IBOutlet weak var btnCheckBoxCash:UIButton!
    @IBOutlet weak var lblCash: UILabel!
    @IBOutlet weak var btnCheckBoxCheck:UIButton!
    @IBOutlet weak var lblCheck: UILabel!
    @IBOutlet weak var lblBank: UILabel!
    @IBOutlet weak var txtFieldBank:UITextField!
    @IBOutlet weak var lblCheckNo: UILabel!
    @IBOutlet weak var txtFieldCheckNo:UITextField!
    @IBOutlet weak var lblKind: UILabel!
    private var strKind:String = ""
    @IBOutlet weak var btnCheckBoxBalance:UIButton!
    @IBOutlet weak var lblBalance:UILabel!
    @IBOutlet weak var btnCheckBoxAdvance:UIButton!
    @IBOutlet weak var lblAdvance:UILabel!
    @IBOutlet weak var btnCheckBoxStorno:UIButton!
    @IBOutlet weak var lblStorno:UILabel!
    
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var txtFieldNotes:UITextField!
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblPaid: UILabel!
    @IBOutlet weak var lblPending: UILabel!
    @IBOutlet weak var lblPendingAfterPayment: UILabel!
    @IBOutlet weak var txtFieldCurrentPayment:UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var selectedOrder = Order()
    var arrCredits = [Credit]()
    var selectedCredit: Credit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUIData ()
        self.updatePendingAfterPaymentAmount()
        
        registerButton.isEnabled = false
        registerButton.backgroundColor = UIColor.lightGray
//        self.btnCheckBoxCash.isSelected = true
//        self.btnCheckBoxAdvance.isSelected = true
    }
    
    private func setUIData () {
        self.lblTotalAmount.text = "€ "+"\(self.selectedOrder.amount)"
        self.lblPaid.text = String(format: "%@%.2f","Paid: € ".localized(), (self.selectedOrder.amount-self.selectedOrder.amountPending))
        self.lblPending.text = String(format: "%@%.2f","Still to get: € ".localized(), self.selectedOrder.amountPending)
        btnCheckBoxCash.setImage(UIImage(named:"Checkmarkempty"), for: .normal)
        btnCheckBoxCash.setImage(UIImage(named:"Checkmark"), for: .selected)
        btnCheckBoxCheck.setImage(UIImage(named:"Checkmarkempty"), for: .normal)
        btnCheckBoxCheck.setImage(UIImage(named:"Checkmark"), for: .selected)
        
        btnCheckBoxBalance.setImage(UIImage(named:"Checkmarkempty"), for: .normal)
        btnCheckBoxBalance.setImage(UIImage(named:"Checkmark"), for: .selected)
        btnCheckBoxAdvance.setImage(UIImage(named:"Checkmarkempty"), for: .normal)
        btnCheckBoxAdvance.setImage(UIImage(named:"Checkmark"), for: .selected)
        btnCheckBoxStorno.setImage(UIImage(named:"Checkmarkempty"), for: .normal)
        btnCheckBoxStorno.setImage(UIImage(named:"Checkmark"), for: .selected)
        
    }
    
    //MARK:- checkMarkTapped
    @IBAction func checkPayementMarkTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
        }) { (success) in
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = true
                sender.transform = .identity
                if (sender == self.btnCheckBoxCheck) {
                    self.btnCheckBoxCash.isSelected = false
                    self.btnCheckBoxCash.transform = .identity
                    self.strPaymentMethod = "Check"
                }
                else {
                    self.btnCheckBoxCheck.isSelected = false
                    self.btnCheckBoxCheck.transform = .identity
                    self.strPaymentMethod = "Cash"
                }
                self.updatePendingAfterPaymentAmount()
            }, completion: nil)
        }
    }
    
    
    @IBAction func checkKindMarkTapped(_ sender: UIButton) {
        if (sender.isEqual(btnCheckBoxBalance)) {
            let amountString = String(Int(self.selectedOrder.amountPending * 100)).currencyInputFormatting()
            txtFieldCurrentPayment.text = amountString.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
            self.updatePendingAfterPaymentAmount()
        }
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
        }) { (success) in
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
                if (sender == self.btnCheckBoxBalance) {
                    sender.isSelected = true
                    sender.transform = .identity
                    self.btnCheckBoxAdvance.isSelected = false
                    self.btnCheckBoxAdvance.transform = .identity
                    self.btnCheckBoxStorno.isSelected = false
                    self.btnCheckBoxStorno.transform = .identity
                    self.strKind = "balance"
                    self.selectedCredit = nil
                }
                else if (sender == self.btnCheckBoxAdvance) {
                    sender.isSelected = true
                    sender.transform = .identity
                    self.btnCheckBoxBalance.isSelected = false
                    self.btnCheckBoxBalance.transform = .identity
                    self.btnCheckBoxStorno.isSelected = false
                    self.btnCheckBoxStorno.transform = .identity
                    self.strKind = "advance"
                    self.selectedCredit = nil
                }
                else {
                    sender.transform = .identity
                    let creditPicker = self.storyboard!.instantiateViewController(withIdentifier: "CreditPickerViewController") as! CreditPickerViewController
                    let navVC = UINavigationController(rootViewController: creditPicker)
                    creditPicker.delegate = self
                    creditPicker.arrCredits = self.arrCredits
                    creditPicker.title = "Seleziona Documento di Storno"
                    navVC.modalPresentationStyle = .popover
                    navVC.popoverPresentationController?.sourceView = self.btnCheckBoxStorno
                    navVC.preferredContentSize = CGSize(width: 600, height: 600)
                    navVC.navigationBar.isTranslucent = false

//                    alert.popoverPresentationController?.permittedArrowDirections = .right
                    self.present(navVC, animated: true, completion: nil)
                }
                self.updatePendingAfterPaymentAmount()
            }, completion: nil)
        }
    }
    
    private func updatePendingAfterPaymentAmount() {
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        let text = self.txtFieldCurrentPayment.text!
        let amountWithPrefix = regex.stringByReplacingMatches(in: text, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, text.count), withTemplate: "")
        let double = (amountWithPrefix as NSString).floatValue / 100
        let currentPayment = double
        let paid = self.selectedOrder.amount-self.selectedOrder.amountPending
        let pendingAfterPayment = SharedClass.shared.getFloatToThreeDigitFrom(number: (self.selectedOrder.amount-paid-currentPayment))
        self.lblPendingAfterPayment.text = "To have € ".localized()+"\(pendingAfterPayment)"
        
        if (pendingAfterPayment >= 0) {
            txtFieldCurrentPayment.textColor = UIColor.black
            if (strPaymentMethod != "" && strKind != "") {
                registerButton.isEnabled = true
                registerButton.backgroundColor = UIColor(red: 0, green: 140/255, blue: 65/255, alpha: 1)
            }
        } else {
            txtFieldCurrentPayment.textColor = UIColor.red
            registerButton.isEnabled = false
            registerButton.backgroundColor = UIColor.lightGray
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let amountString = text.currencyInputFormatting()
        textField.text = amountString.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        self.updatePendingAfterPaymentAmount()
        return false
    }
    
    func redirectToTransactionReceipt(transactionResponse:Original) {
        let sb = UIStoryboard(name: Constants.StoryBoard.homeSB, bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifier.orderStatusViewController) as? OrderStatusViewController {
            let currentTransaction = Transaction.init(transactionId: transactionResponse.id!, number: transactionResponse.number!, transactionDate: transactionResponse.createdAt!, price: Float(transactionResponse.price!), transactionType: transactionResponse.payment!, chequeNo: transactionResponse.checkNumber ?? "", bank: transactionResponse.bank ?? "", kind: transactionResponse.kind ?? "", notes: transactionResponse.notes ?? "")
            vc.selectedTrans = currentTransaction
            vc.selectedOrder = selectedOrder
            vc.currentUIState = .transactionCompleted
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func recordTransactionAction(_ sender: UIButton) {
                txtFieldBank.resignFirstResponder()
                txtFieldCheckNo.resignFirstResponder()
                txtFieldNotes.resignFirstResponder()
                txtFieldCurrentPayment.resignFirstResponder()
        
                if txtFieldCurrentPayment.text!.isEmpty {
                    Constants.showAlert(message: String.strTransactionEmpty)
                    return
                }
                if self.strPaymentMethod == "Check"  {
                    if self.txtFieldBank.text!.isEmpty {
                        Constants.showAlert(message: String.strBankEmpty)
                        return
                    }
                    else if self.txtFieldCheckNo.text!.isEmpty {
                        Constants.showAlert(message: String.strCheckNoEmpty)
                        return
                    }
                }
        
                Constants.showLoader()
        APIManager.shared.makeTransactionWith(orderId: self.selectedOrder.id, kind: self.strKind, payment:self.strPaymentMethod, bank: (self.txtFieldBank.text ?? ""), checkNumber: (self.txtFieldCheckNo.text ?? ""), price: "\(txtFieldCurrentPayment!.text!.currentValue())", notes: txtFieldNotes.text ?? "", credit: selectedCredit) { (transactionResponse,success) in
                    Constants.hideLoader()
                    if success {
                        self.redirectToTransactionReceipt(transactionResponse: (transactionResponse?.original)!)
                    }
                    else {
                        Constants.showAlert(message: "Please input lower amount".localized())
                    }
                }
    }
    
    override func leftNavigationAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func convertDoubleToCurrency(amount: Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
    func convertCurrencyToDouble(input: String) -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter.number(from: input)?.doubleValue
    }
    
    var typedValue: Int = 0
    func typedValueToCurrency(typedValue:Int) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        let amount = Double(typedValue/100) +
            Double(typedValue%100)/100
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
    func pickCredit(_ credit: Credit) {
        btnCheckBoxStorno.isSelected = true
        btnCheckBoxStorno.transform = .identity
        btnCheckBoxAdvance.isSelected = false
        btnCheckBoxAdvance.transform = .identity
        btnCheckBoxBalance.isSelected = false
        btnCheckBoxBalance.transform = .identity
        strKind = "storno"
        
        selectedCredit = credit
        
        let amountString = String(Int(credit.avere * 100)).currencyInputFormatting()
        txtFieldCurrentPayment.text = amountString.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        self.updatePendingAfterPaymentAmount()
    }
}

extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        number = NSNumber(value: currentValue())
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    
    func currentValue() -> Double {
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        let amountWithPrefix = regex.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        return (amountWithPrefix as NSString).doubleValue / 100
    }
}
