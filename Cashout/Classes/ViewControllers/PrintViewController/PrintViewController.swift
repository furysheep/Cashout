//
//  PrintViewController.swift
//  Cashout
//

import UIKit

class PrintViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var lblRecipt: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblOrder: UILabel!
    @IBOutlet weak var lblTransaction: UILabel!
    @IBOutlet weak var lblRecipient: UILabel!
    @IBOutlet weak var lblThisTransaction: UILabel!
    @IBOutlet weak var lblPaymentMethod: UILabel!
    @IBOutlet weak var lblBank: UILabel!
    @IBOutlet weak var lblComments: UILabel!
    @IBOutlet weak var lblCheckNo: UILabel!
    @IBOutlet weak var lblSellerNameAddress: UILabel!
    @IBOutlet weak var lblAgentCode: UILabel!
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tblViewPrint: UITableView!
    
    var selectedOrder = Order()
    var selectedTrans = Transaction()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tblViewPrint?.rowHeight = 44.0
        self.setUI()
        
    }
    
    private func setUI() {
        // self.lblRecipt.text?.append(contentsOf: <#T##String#>)
        self.lblDate.text = String.init(format: "%@: %@", "Date".localized(),self.selectedTrans.transactionDate)
        self.lblOrder.text = String(format: "%@%@", "Order #".localized(),self.selectedOrder.number)
        self.lblTransaction.text = String.init(format: "%@%@", "Transaction #".localized(),self.selectedTrans.number)
        self.lblRecipient.text = String.init(format: "%@\n%@", "Recipient: ".localized(),SharedClass.shared.currentSelectedCustomer.address)
        self.lblThisTransaction.text = "This transaction:".localized() + "\n\(self.selectedTrans.price) €"
        self.lblPaymentMethod.text = String.init(format: "%@\n%@", "Payment method:".localized(),self.selectedTrans.transactionType)
        self.lblBank.text = String.init(format: "%@%@", "Bank:".localized(),self.selectedTrans.bank)
        self.lblComments.text = String.init(format: "%@\n%@", "Comments/Notes".localized(),self.selectedOrder.note.trimSpace() == "" ? "no note".localized() : self.selectedOrder.note)
        self.lblCheckNo.text = String.init(format: "%@%@", "CheckNo:".localized(),self.selectedTrans.chequeNo)
        self.lblSellerNameAddress.text = self.computeSellerDetails()
        self.lblAgentCode.text = String.init(format: "%@ %@", "Agent:".localized(),(UserManager.shared.loggedInUser?.agentCode)!)
        self.tblViewPrint.setNeedsLayout()
        self.tblViewPrint.layoutIfNeeded()
    }
    
    private func computeSellerDetails() -> String {
        let sellerDetail = """
        \((UserManager.shared.loggedInUser?.company?.first?.name!)!)
        \((UserManager.shared.loggedInUser?.company?.first?.completeAddress)!)
        \("P.IVA:".localized())\((UserManager.shared.loggedInUser?.company?.first?.pIVA)!)\n\("CF: ".localized())\((UserManager.shared.loggedInUser?.company?.first?.cF)!)
        """
        return sellerDetail
    }
    
    // MARK: - UITableView Delegate & Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedOrder.Items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell:PrintTableViewCell = tblViewPrint.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.printTableViewCellIdentifier, for: indexPath) as! PrintTableViewCell
        cell.selectionStyle = .none
        cell.configureItem(item: self.selectedOrder.Items[indexPath.row])
        return cell
    }
}
