//
//  CustomerListViewController.swift
//  Cashout
//


import UIKit
import SwiftyJSON

class CustomerListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblViewCustomers: UITableView!
    
    private var arrClientList = [Customer]()
    private var arrSearchResults:Array<Customer>?
    var searchActive : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setSearchBarUI()
        Constants.showLoader()
        APIManager.shared.getCustomersList { (result) in
            Constants.hideLoader()
            self.parser(arr: result!)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func parser(arr:[JSON]) {
        for each in arr {
            let dict = each.dictionaryValue
            let address = (dict["address"]?.stringValue) ?? ""
            let city = (dict["city"]?.stringValue) ?? ""
            let district = (dict["district"]?.stringValue) ?? ""
            let zip = (dict["zip"]?.stringValue) ?? ""
            let completeAddress:String = "\(address), \(city), \(district) - \(zip)"
            
            let client = Customer.init(id: (dict["id"]?.stringValue)!, firstName: (dict["fname"]?.stringValue)!, lastName: (dict["lname"]?.stringValue)!, companyName: (dict["company"]?.stringValue)!, address: completeAddress, phoneNo: (dict["phone"]?.stringValue)!, email: (dict["email"]?.stringValue)!, PIVA: (dict["PIVA"]?.stringValue)!, CF: (dict["CF"]?.stringValue)!, SID: "", customerId: ((dict["fname"]?.stringValue)!))
            self.arrClientList.append(client)
        }
        self.tblViewCustomers.reloadData()
        self.redirectToCustomerDetails(customer: self.arrClientList[0])
    }
    
    func setSearchBarUI() {
        let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.dropShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), offset: CGSize(width:1.0,height: 2.0))
        //        textFieldInsideSearchBar?.backgroundColor = UIColor.white
        //        textFieldInsideSearchBar?.textColor =
        
        var placeHolder = NSMutableAttributedString()
        let txtPlaceholder = "Search...".localized()
        // Set the Font
        placeHolder = NSMutableAttributedString(string:txtPlaceholder, attributes: [NSAttributedString.Key.font:UIFont(name: "Helvetica", size: 17.0)!])
        // Set the color
        //placeHolder.addAttribute(NSAttributedString.Key.foregroundColor, value: , range:NSRange(location:0,length:txtPlaceholder.characters.count))
        
        // Add attribute
        textFieldInsideSearchBar?.attributedPlaceholder = placeHolder
        
        self.searchBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.searchBar.layer.borderWidth = 1;
        self.searchBar.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.searchBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        // self.viewSearch.layoutIfNeeded()
        //self.searchBar.becomeFirstResponder()
    }
    
    // MARK: - UITableView Delegate & Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return arrSearchResults!.count
        }
        return arrClientList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell:CustomerTableViewCell = tblViewCustomers.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.customerTableViewCellIdentifier, for: indexPath) as! CustomerTableViewCell
        cell.selectionStyle = .none
        if(searchActive){
            cell.configure(client: self.arrSearchResults![indexPath.row])
        } else {
            cell.configure(client: self.arrClientList[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.redirectToCustomerDetails(customer: self.arrClientList[indexPath.row])
    }
    
    // MARK: Search bar delegates
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)  {
        let trimmedString = searchText.trimmingCharacters(in: .whitespaces)
        self.filterContentForSearchText(searchText: trimmedString)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    private func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        if self.arrClientList.isEmpty {
            return
        }
        self.arrSearchResults = self.arrClientList.filter { (currentCustomer:Customer) -> Bool in
            return currentCustomer.companyName.lowercased().range(of:searchText.lowercased()) != nil
        }
        if(searchText.count>0){
            searchActive = true;
        } else {
            searchActive = false;
        }
        self.tblViewCustomers.reloadData()
    }
    
    private func redirectToCustomerDetails (customer:Customer) {
        let sb = UIStoryboard(name: Constants.StoryBoard.homeSB, bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifier.customerViewController) as? CustomerViewController {
            let selectedCustomer = Customer.init(value:customer)
            vc.selectedCustomer = selectedCustomer
            SharedClass.shared.currentSelectedCustomer = selectedCustomer
            vc.isBtnBackHidden = true
            print(UIDevice.current.userInterfaceIdiom)
            if UIDevice.current.userInterfaceIdiom == .pad {
                let sb1 = UIStoryboard(name: Constants.StoryBoard.homeIpadSB, bundle: nil)
                if let vc1 = sb1.instantiateViewController(withIdentifier: "SplitDetailNavigation") as? UINavigationController {
                    vc1.setViewControllers([vc], animated: true)
                    self.splitViewController?.showDetailViewController(vc1, sender: self)
                }
            }
            else {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
