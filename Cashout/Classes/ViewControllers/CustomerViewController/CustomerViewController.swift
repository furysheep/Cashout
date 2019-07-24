//
//  CustomerViewController.swift
//  Cashout
//


import UIKit
//import Kingfisher
import SwiftyJSON

class CustomerViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var imgViewCustomer: UIImageView!
    @IBOutlet weak var lblCompanyNameTitle: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhoneNo: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPIVA: UILabel!
    @IBOutlet weak var lblCF: UILabel!
    @IBOutlet weak var lblSID: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tblViewOrders: UITableView!
    
    private var arrOpenOrderList = [Order]()
    private var arrCompletedOrderList = [Order]()
    private var arrCancelledOrderList = [Order]()
    
    let buttonBar = UIView()
    var selectedCustomer = Customer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "\(self.selectedCustomer.companyName)"
        self.setLabelUI()
        self.setSegmentedControlUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Constants.showLoader()
        APIManager.shared.makeGetCallWithAlamofireCustomerOrders(id: self.selectedCustomer.id) { (result,success) in
            Constants.hideLoader()
            if success {
                self.parser(arr: result!)
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.clearData()
    }
    
    private func clearData() {
        self.selectedCustomer.orders.removeAll()
        self.arrOpenOrderList.removeAll()
        self.arrCompletedOrderList.removeAll()
        self.arrCancelledOrderList.removeAll()
    }
    
    private func parser(arr:[JSON]) {
        for each in arr {
            let dict = each.dictionaryValue
            let orderProducts = dict["products_count"]!.int
            var itemCount:Int = 0
            if orderProducts!>0 {
                itemCount = orderProducts!
            }
            else {
                continue
            }
            //Open (Open: DOES HAVE a registry_id set)
            let registryId = (dict["registry_id"]?.stringValue) ?? ""
            let status = (dict["status"]?.int) ?? -1
            var computedStatus = 0
            if (registryId != "") {
                computedStatus = status+1
            }
            else {
                continue
            }
            
            let orderId = (dict["id"]?.stringValue) ?? ""
            let orderNumber = (dict["order_number"]?.stringValue) ?? ""
            let notes = (dict["notes"]?.stringValue) ?? ""
            let orderTotal = (dict["total"]?.floatValue) ?? 0.0
            let orderPendingAmount = (orderTotal - ((dict["transaction_sum"]?.floatValue) ?? 0.0))
            
            let parsedOrder = Order.init(id:orderId, number:orderNumber, status: Order.orderStatus(rawValue: computedStatus)!, itemCount: itemCount, amount: orderTotal, amountPending: orderPendingAmount,note:notes)
            self.selectedCustomer.orders.append(parsedOrder)
        }
        
        for each in self.selectedCustomer.orders {
            switch (each.status) {
            case 1:
                self.arrOpenOrderList.append(each)
            case 2:self.arrCompletedOrderList.append(each)
            case 3:self.arrCancelledOrderList.append(each)
            default:
                print("a")
            }
        }
        self.tblViewOrders.reloadData()
    }
    
    private func setLabelUI() {
        self.imgViewCustomer.image = #imageLiteral(resourceName: "dummy")
        self.lblCompanyNameTitle.text = self.selectedCustomer.companyName
        self.lblCompanyName.attributedText = self.setLabelUIStyle(attributeString: "Business Name: ".localized(), dynamicData:self.selectedCustomer.companyName)
        self.lblName.attributedText = self.setLabelUIStyle(attributeString: "Name: ".localized(), dynamicData:self.selectedCustomer.firstName+" "+self.selectedCustomer.lastName)
        self.lblAddress.attributedText = self.setLabelUIStyle(attributeString: "Address: ".localized(), dynamicData:self.selectedCustomer.address)
        self.lblPhoneNo.attributedText = self.setLabelUIStyle(attributeString: "Phone: ".localized(), dynamicData:self.selectedCustomer.phoneNo)
        self.lblEmail.attributedText = self.setLabelUIStyle(attributeString: "Email: ".localized(), dynamicData:self.selectedCustomer.email)
        self.lblPIVA.attributedText = self.setLabelUIStyle(attributeString: "P.IVA: ".localized(), dynamicData:self.selectedCustomer.PIVA)
        self.lblCF.attributedText = self.setLabelUIStyle(attributeString: "CF: ".localized(), dynamicData:self.selectedCustomer.CF)
        self.lblSID.attributedText = self.setLabelUIStyle(attributeString: "SID: ".localized(), dynamicData:self.selectedCustomer.SID)
    }
    
    func setLabelUIStyle(attributeString:String, dynamicData regularString:String) -> NSMutableAttributedString {
        let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 14.0)! ]
        let myString = NSMutableAttributedString(string: attributeString, attributes: myAttribute )
        let attrString = NSAttributedString(string:regularString)
        myString.append(attrString)
        return myString
    }
    
    func setLabelData () {
        self.setLabelUI()
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
        self.tblViewOrders.reloadData()
    }
    
    // MARK: - UITableView Delegate & Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            return self.arrOpenOrderList.count
        }
        else if self.segmentedControl.selectedSegmentIndex == 1 {
            return self.arrCompletedOrderList.count
        }
        else{
            return self.arrCancelledOrderList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell:OrderTableViewCell = tblViewOrders.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.orderTableViewCellIdentifier, for: indexPath) as! OrderTableViewCell
        cell.selectionStyle = .none
        
        if self.segmentedControl.selectedSegmentIndex == 0 {
            cell.configure(selectedSegment: self.segmentedControl.selectedSegmentIndex, order: self.arrOpenOrderList[indexPath.row])
        }
        else if self.segmentedControl.selectedSegmentIndex == 1 {
            cell.configure(selectedSegment: self.segmentedControl.selectedSegmentIndex, order: self.arrCompletedOrderList[indexPath.row])
        }
        else {
            cell.configure(selectedSegment: self.segmentedControl.selectedSegmentIndex, order: self.arrCancelledOrderList[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: Constants.StoryBoard.homeSB, bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifier.orderDetailsViewController) as? OrderDetailsViewController {
            if self.segmentedControl.selectedSegmentIndex == 0 {
                let selectedOrder = Order.init(value:self.arrOpenOrderList[indexPath.row])
                vc.selectedOrder = selectedOrder
            }
            else if self.segmentedControl.selectedSegmentIndex == 1 {
                let selectedOrder = Order.init(value:self.arrCompletedOrderList[indexPath.row])
                vc.selectedOrder = selectedOrder
            }
            else {
                let selectedOrder = Order.init(value:self.arrCancelledOrderList[indexPath.row])
                vc.selectedOrder = selectedOrder
            }
            vc.companyName = self.selectedCustomer.companyName
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func leftNavigationAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
