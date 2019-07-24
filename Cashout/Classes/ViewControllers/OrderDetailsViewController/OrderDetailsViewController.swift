//
//  OrderDetailsViewController.swift
//  Cashout
//


import UIKit
import SwiftyJSON

class OrderDetailsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var imgViewCustomer: UIImageView!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblTotalHeader: UILabel!
    @IBOutlet weak var lblOrderTotalAmount: UILabel!
    @IBOutlet weak var lblPendingHeader: UILabel!
    @IBOutlet weak var lblAmountPending: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tblViewArticles: UITableView!
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var viewCashout: UIView!
    
    private let buttonBar = UIView()
    var selectedOrder = Order()
    var companyName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Order".localized()+" \(self.selectedOrder.number)"
        self.setLabelUI()
        self.lblOrderTotalAmount.text = "€ " + "\(self.selectedOrder.amount)"
        self.setSegmentedControlUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Constants.showLoader()
        APIManager.shared.makeGetCallWithAlamofireOrder(id: self.selectedOrder.id) { (result,success) in
            Constants.hideLoader()
            if success {
                self.parser(arr: result!)
            }
            else {
                Constants.showAlert(message: "Please Retry")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.clearData()
    }
    
    private func clearData() {
        self.selectedOrder.Items.removeAll()
        self.selectedOrder.Transactions.removeAll()
    }
    
    func parser(arr:[JSON]) {
        for each in arr {
            let dict = each.dictionaryValue
            let orderProducts = dict["products"]!.arrayValue
            for each in orderProducts {
                let dict = each.dictionaryValue
                
                let itemId = (dict["id"]?.stringValue) ?? ""
                let itemName = (dict["name"]?.stringValue) ?? ""
                let itemDescription = (dict["description"]?.stringValue) ?? ""
                let itemPrice = (dict["price"]?.floatValue) ?? 0.0
                
                let parsedItem = Item.init(id: itemId, itemId: "", name: itemName, itemDescription: itemDescription, price: itemPrice)
                self.selectedOrder.Items.append(parsedItem)
            }
            
            let orderTransactions = dict["transactions"]!.arrayValue
            
            if orderTransactions.count>0 {
                for each1 in orderTransactions {
                    let dict1 = each1.dictionaryValue
                    let transId = (dict1["id"]?.stringValue) ?? ""
                    let transNo = (dict1["number"]?.stringValue) ?? ""
                    let transType = (dict1["payment"]?.stringValue) ?? ""
                    let transBank = (dict1["bank"]?.stringValue) ?? ""
                    let transCheckNo = (dict1["check_number"]?.stringValue) ?? ""
                    let transAmount = (dict1["price"]?.floatValue) ?? 0.00
                    var transDate = (dict1["created_at"]?.stringValue) ?? ""
                    if !transDate.isEmpty {
                        let commaSeperated = transDate.components(separatedBy:" ")
                        transDate = commaSeperated[0]
                    }
                    
                    let parsedTransaction = Transaction.init(transactionId: transId, number: transNo, transactionDate: transDate, price: transAmount, transactionType: Constants.getTransactionType(type: transType),chequeNo: transCheckNo,bank: transBank)
                    self.selectedOrder.Transactions.append(parsedTransaction)
                }
            }
        }
        self.tblViewArticles.reloadData()
    }
    
    private func setLabelUI() {
        self.imgViewCustomer.image = #imageLiteral(resourceName: "dummy")
        self.lblCompanyName.text = self.companyName
        self.lblOrderTotalAmount.text = String(format: "€ %.2f", self.selectedOrder.amount)
        if (self.selectedOrder.status == Order.orderStatus.orderCancel.rawValue) {
            self.lblTotalHeader.text = "Order Cancelled".localized()
            self.lblTotalHeader.textColor = #colorLiteral(red: 0.8784313725, green: 0.1254901961, blue: 0.1254901961, alpha: 1)
            self.lblOrderTotalAmount.textColor = #colorLiteral(red: 0.8784313725, green: 0.1254901961, blue: 0.1254901961, alpha: 1)
            self.lblPendingHeader.isHidden = true
            self.lblAmountPending.isHidden = true
        }
        else if (self.selectedOrder.status == Order.orderStatus.orderComplete.rawValue) {
            self.lblTotalHeader.text = "Order Completed".localized()
            self.lblTotalHeader.textColor = #colorLiteral(red: 0, green: 0.5490196078, blue: 0.2549019608, alpha: 1)
            self.lblOrderTotalAmount.textColor = #colorLiteral(red: 0, green: 0.5490196078, blue: 0.2549019608, alpha: 1)
            self.lblPendingHeader.isHidden = true
            self.lblAmountPending.isHidden = true
        }
        else {
            self.lblAmountPending.text = String(format: "€ %.2f", self.selectedOrder.amountPending)
            
        }
    }
    
    // MARK: - UISegmentedControl Customization
    func setSegmentedControlUI() {
        // Add lines below the segmented control's tintColor
        self.segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "AvenirNext-Regular", size: 13) as Any,NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ], for: .normal)
        
        self.segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "AvenirNext-Regular", size: 13) as Any,
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            ], for: .selected)
        
        // This needs to be false since we are using auto layout constraints
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.addSubview(buttonBar)
        
        // Constrain the top of the button bar to the bottom of the segmented control
        buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 1).isActive = true
        // Constrain the button bar to the left side of the segmented control
        buttonBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor).isActive = true
        // Constrain the button bar to the width of the segmented control divided by the number of segments
        buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
        
        segmentedControl.addTarget(self, action: #selector(self.segmentedControlValueChanged(_:)), for: UIControl.Event.valueChanged)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.2) {
            self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
        }
        UIView.animate(withDuration: 0.2) {
            if self.segmentedControl.selectedSegmentIndex == 0 || self.segmentedControl.selectedSegmentIndex == 1 {
                self.viewCancel.isHidden = true
                self.tblViewArticles.isHidden = false
                self.viewCashout.isHidden = true
            }
            else {
                if (self.selectedOrder.status == Order.orderStatus.orderOpen.rawValue) {
                    self.tblViewArticles.isHidden = true
                    self.viewCancel.isHidden = false
                    self.viewCashout.isHidden = true
                }
                else {
                    self.tblViewArticles.isHidden = true
                    self.viewCancel.isHidden = true
                    self.viewCashout.isHidden = false
                }
            }
        }
        self.tblViewArticles.reloadData()
    }
    
    // MARK: - UITableView Delegate & Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            return self.selectedOrder.Items.count
        }
        else {
            return self.selectedOrder.Transactions.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell:ArticlesTableViewCell = tblViewArticles.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.articlesTableViewCellIdentifier, for: indexPath) as! ArticlesTableViewCell
        cell.selectionStyle = .none
        if self.segmentedControl.selectedSegmentIndex == 0 {
            cell.configureItem(item: self.selectedOrder.Items[indexPath.row])
        }
        else if self.segmentedControl.selectedSegmentIndex == 1 {
            cell.configureTransaction(trans:self.selectedOrder.Transactions[indexPath.row])
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: Constants.StoryBoard.homeSB, bundle: nil)
        if self.segmentedControl.selectedSegmentIndex == 1 {
            if let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifier.orderStatusViewController) as? OrderStatusViewController {
                vc.selectedTrans = self.selectedOrder.Transactions[indexPath.row]
                vc.selectedOrder = self.selectedOrder
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    @IBAction func orderCompleteAction(_ sender: UIButton) {
        //        let sb = UIStoryboard(name: Constants.StoryBoard.homeSB, bundle: nil)
        //        if let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifier.orderStatusViewController) as? OrderStatusViewController {
        //            vc.currentUIState = .orderCompleted
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        }
    }
    
    @IBAction func registerTransactionAction(_ sender: Any) {
        let sb = UIStoryboard(name: Constants.StoryBoard.homeSB, bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifier.transactionViewController) as? TransactionViewController {
            vc.selectedOrder = self.selectedOrder
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    //    "id":String, #Order id
    //    "status":Int, #1 = completed, 2 = cancelled
    //    "complete":Bool, #true only for status
    @IBAction func orderCancelAction(_ sender: UIButton) {
        Constants.showLoader()
        APIManager.shared.updateOrderStatusWith(id: self.selectedOrder.id, status: 2, complete: false) { (updateOrderResponse,success) in
            Constants.hideLoader()
            if success {
                self.redirectToOrderCancelled(updateOrderResponse:updateOrderResponse!)
            }
            else {
                Constants.showAlert(message: "Please Retry")
            }
        }
    }
    
    func redirectToOrderCancelled(updateOrderResponse:UpdateOrderResponse) {
        let sb = UIStoryboard(name: Constants.StoryBoard.homeSB, bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifier.orderStatusViewController) as? OrderStatusViewController {
            //            let currentTransaction = Transaction.init(transactionId: updateOrderResponse., number: transactionResponse.number!, transactionDate: transactionResponse.created_at!, price: Float(transactionResponse.price!), transactionType: transactionResponse.payment!, chequeNo: transactionResponse.check_number!, bank: transactionResponse.bank!)
            //            vc.selectedTrans = currentTransaction
            vc.selectedOrder = selectedOrder
            vc.currentUIState = .orderCancelled
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func leftNavigationAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
