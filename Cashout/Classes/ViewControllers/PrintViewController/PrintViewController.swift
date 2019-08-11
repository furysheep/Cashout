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
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var tblViewPrint: UITableView!
    @IBOutlet weak var lblPrint: UILabel!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lastView: UIView!
    
    var selectedOrder = Order()
    var selectedTrans = Transaction()
    var selectedItem = Item()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tblViewPrint?.rowHeight = 44.0
        self.setUI()
        
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        let header = tblViewPrint.tableHeaderView!
//        header.setNeedsUpdateConstraints()
//        header.updateConstraintsIfNeeded()
//        header.frame = CGRect(x: 0, y: 0, width: tblViewPrint.tableHeaderView!.bounds.size.width, height: CGFloat.greatestFiniteMagnitude)
//        var newFrame = header.frame
//        header.setNeedsLayout()
//        header.layoutIfNeeded()
//        let newSize = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//        newFrame.size.height = newSize.height
//        header.frame = newFrame
//    }
    
    override func viewDidLayoutSubviews() {
        view.bounds = CGRect(x: 0, y: 0, width: view.bounds.width, height: lastView.frame.origin.y + lastView.frame.size.height + 50)
    }
    
    private func setUI() {
        // self.lblRecipt.text?.append(contentsOf: <#T##String#>)
        self.lblDate.text = String.init(format: "%@: %@", "Date".localized(),self.selectedTrans.transactionDate.split(separator: "-").reversed().joined(separator: "/"))
        self.lblOrder.text = String(format: "%@%@", "Order #".localized(),self.selectedOrder.number)
        self.lblTransaction.text = String.init(format: "%@%@", "Transaction #".localized(),self.selectedTrans.number)
        self.lblRecipient.text = String.init(format: "%@\n%@\n%@", "Recipient:".localized(), SharedClass.shared.currentSelectedCustomer.companyName, SharedClass.shared.currentSelectedCustomer.address)
        if (self.selectedTrans.kind == "storno") {
            self.lblThisTransaction.text = "This transaction:".localized() + "\n\(self.selectedTrans.price) €  \n(\(self.selectedTrans.kind.capitalized.localized()): \(self.selectedTrans.stornoDoc))"
        } else {
            self.lblThisTransaction.text = "This transaction:".localized() + "\n\(self.selectedTrans.price) €  (\(self.selectedTrans.kind.capitalized.localized()))"
        }
        self.lblPaymentMethod.text = String.init(format: "%@\n%@", "Payment method:".localized(),self.selectedTrans.transactionType)
        self.lblBank.text = String.init(format: "%@: %@", "Bank".localized(), self.selectedTrans.bank.localized())
        self.lblComments.text = String.init(format: "%@\n%@", "Comments/Notes".localized(),self.selectedTrans.notes.trimSpace() == "" ? "no note".localized() : self.selectedTrans.notes)
        self.lblCheckNo.text = String.init(format: "%@: %@", "Check".localized(),self.selectedTrans.chequeNo)
        self.lblSellerNameAddress.text = self.computeSellerDetails()
        self.lblAgentCode.text = String.init(format: "%@ %@", "Agent:".localized(),(UserManager.shared.loggedInUser?.agentCode)!)
        self.tblViewPrint.setNeedsLayout()
        self.tblViewPrint.layoutIfNeeded()
        
        self.lblDesc.text = selectedItem.itemDescription
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        self.lblPrint.text = String(format: "%@ %@", "Print".localized(), dateString)
        
        if (self.selectedOrder.Items.count == 0) {
            tableHeightConstraint.constant = 0
        }
    }
    
    private func computeSellerDetails() -> String {
        let sellerDetail = """
        \((UserManager.shared.loggedInUser?.company?.first?.name!)!)
        \((UserManager.shared.loggedInUser?.company?.first?.completeAddress)!)
        \("P.IVA:".localized())\(UserManager.shared.loggedInUser?.company?.first?.pIVA ?? "")\n\("CF: ".localized())\(UserManager.shared.loggedInUser?.company?.first?.cF ?? "")
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
        
        tableHeightConstraint.constant = tableView.contentSize.height
        return cell
    }
}
