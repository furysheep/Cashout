//
//  RegoPrinterSelectViewController.swift
//  Cashout
//
//  Created by Mistook on 7/24/19.
//  Copyright © 2019 demo. All rights reserved.
//

import UIKit

class RegoPrinterSelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DropDownChooseDelegate, DropDownChooseDataSource, UITextFieldDelegate {
    var receiptImage: UIImage!
    
    let mPrinter = regoPrinter.shareManager() as! regoPrinter
    var nameArr = [String]()
    var modelsDropDownView: DropDownListView? = nil
    var per: String? = nil
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var viewWIFI: UIView!
    @IBOutlet weak var viewBT: UIView!
    @IBOutlet weak var viewNext: UIView!
    @IBOutlet weak var IPAddr: UITextField!
    @IBOutlet weak var IPPort: UITextField!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var tableViewBT: UITableView!
    @IBOutlet weak var IPConnect: UIButton!
    
    var cell: UITableViewCell!
    var m_PrinterDataMulArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameArr = mPrinter.con_GetSupportPrinters() as! [String]
        nameArr[0] = "RG_MTP_58B"
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if (modelsDropDownView == nil) {
            modelsDropDownView = DropDownListView(frame: CGRect(x: 128, y: 30, width: view.frame.size.width - 158, height: 40), dataSource: self, delegate: self)
            modelsDropDownView!.mSuperView = view
            view.addSubview(modelsDropDownView!)
            
            let userDefaults = UserDefaults.standard
            IPAddr.text = userDefaults.string(forKey: "ip")
            IPPort.text = userDefaults.string(forKey: "port")
            
            var str = UserDefaults.standard.string(forKey: "value")
            if (str != nil) {
                modelsDropDownView!.setTitle(str!, inSection: 0)
            } else {
                str = nameArr[0]
                modelsDropDownView!.setTitle(nameArr[0], inSection: 0)
            }
            mPrinter.stringName = str
            
            let selected = UserDefaults.standard.integer(forKey: "selected")
            segment.selectedSegmentIndex = selected
        }
    }
    
    @IBAction func onSegmentControl(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(segment.selectedSegmentIndex, forKey: "selected")
        userDefaults.synchronize()
    }
    
    @IBAction func selectBT(_ sender: Any) {
        viewNext.isHidden = false
        viewBT.isHidden = false
        viewWIFI.isHidden = true
        
        mPrinter.con_InitLib(_PT_BLUETOOTH)
    }
    
    @IBAction func selectWIFI(_ sender: Any) {
        viewNext.isHidden = false
        viewBT.isHidden = true
        viewWIFI.isHidden = false
        
        mPrinter.con_InitLib(_PT_WIFI)
    }
    
    @IBAction func onScan(_ sender: Any) {
        if (scanButton.currentTitle == "Scan"){
            mPrinter.con_GetRemoteBTPrinters(self)
        } else if(scanButton.currentTitle == "Disconnect"){
            mPrinter.con_CloseDevice(0)
            scanButton.setTitle("Scan", for: .normal)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doPrint(_ sender: Any) {
        mPrinter.ascii_CtrlReset(0)
        mPrinter.con_PageStart(0, graphicMode: true, mWidth: 384, mHeight: Int32(receiptImage.size.height))
        mPrinter.con_Pic_start(0)
        mPrinter.con_PrintPicture(receiptImage, aDensity: 0.83)
        mPrinter.con_Pic_end(0)
        
        let segment_selected = UserDefaults.standard.integer(forKey: "selected")
        mPrinter.con_PageEnd(0, tm: TransferMode(rawValue: TransferMode.RawValue(segment_selected)))
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Bluetooth search callback
    @objc func PrintersMulArrayFount(_ peripheralsMulArray: NSMutableArray) {
        //    NSLog(@"获取蓝牙代理函数设备");
        //    NSLog(@"peripheralsMulArray +++++++++++++  %@",peripheralsMulArray);
        m_PrinterDataMulArray = peripheralsMulArray
        tableViewBT.reloadData()
    }
    
    @objc func PrinterFound(_ peripheral: String) {
        per = peripheral
    }
    
    @objc func PrinterStatus(_ iCode: Int) {
        var mess = ""
        
        if (iCode == 1) {
            mess = "Query Status：Correct!"
        } else {
            mess = "Query Status：Short of paper"
        }
        
        let alert = UIAlertController(title: "Query Status", message: mess, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc func PrinterConnected() {
        scanButton.setTitle("Disconnect", for: .normal)
        
        let str = UserDefaults.standard.string(forKey: "value")
        let segment_selected = segment.selectedSegmentIndex
    }
    
    @objc func PrinterClosed() {
        scanButton.setTitle("Scan", for: .normal)
    }
    
    // MARK: TableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m_PrinterDataMulArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cellID";
        cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        
        if (cell == nil) {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
            cell.accessoryType = .disclosureIndicator
        }
        cell.selectionStyle = .none
        
        let deviceItem = m_PrinterDataMulArray[indexPath.row] as! NSDictionary
        let deviceName = deviceItem.object(forKey: "peripheralNameInfo") as? String
        let deviceRSSI = deviceItem.object(forKey: "RSSIInfo") as? Int64
        let deviceMAC = deviceItem.object(forKey: "peripheralMAC") as? String
        
        cell.textLabel?.text = deviceName
        let detailString = String(format: "RSSI:%d(%@)", deviceRSSI ?? 0, deviceMAC ?? "")
        cell.detailTextLabel?.text = detailString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewBT.deselectRow(at: indexPath, animated: true)
        
        let deviceItem = m_PrinterDataMulArray[indexPath.row] as! NSDictionary
        let deviceName = deviceItem.object(forKey: "peripheralNameInfo") as! String
        let deviceMAC = deviceItem.object(forKey: "peripheralMAC") as! String
        let strMode = String(format: "%@(%@)", deviceName, deviceMAC)
        
        //    NSLog(@"strMode:  %@",strMode);
        mPrinter.con_ConnectDevices(strMode, mTimeout: 5)
    }
    
    // MARK: Wifi
    @IBAction func onIPConnect(_ sender: Any) {
        if (IPConnect.currentTitle == "Disconnect") {
            mPrinter.con_CloseDevice(0)
            IPConnect.setTitle("Connect", for: .normal)
        } else {
            let userDefaults = UserDefaults.standard
            let strName = userDefaults.string(forKey: "value")
            
            var strValue: String!
            
            //43 5C 5E 2C 6E 42 59 41 42 54 5F 5B//1920
            //40 54 54 5F 6E 43 5D 48 42 55 54 5E//5400
            //435C5E2C6E425F434255545C
            //435C5E2C6E42594142535E5B
            if (strName == "RG_DS1920") {
                strValue = String(format: "%@:%@,435C5E2C6E42594142535E5B",  IPAddr.text!, IPPort.text!)
            } else {
                strValue = String(format: "%@:%@",  IPAddr.text!, IPPort.text!)
            }
            
            let state = mPrinter.con_ConnectDevices(strValue, mTimeout: 5)
            
            if (state == 5) {
                let segment_selected = userDefaults.integer(forKey: "selected")
                
                let strName = userDefaults.string(forKey: "value")
                
                userDefaults.setValue(IPAddr.text, forKey: "ip")
                userDefaults.setValue(IPPort.text, forKey: "port")
                
                userDefaults.synchronize()
                IPConnect.setTitle("Disconnect", for: .normal)
                //            self.btn.enabled=YES;
                
            }
            else if(state == 3){
                //            NSLog(@"连接失败");
                let alert = UIAlertController(title: "Attention", message: "Connection failed", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - DropDownChooseDelegate
    func choose(atSection section: Int, index: Int) {
        let str = nameArr[index];
        mPrinter.stringName = str
        //持久化
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(str, forKey: "value")
        userDefaults.synchronize()
    }
    
    // MARK: - DropDownChooseDataSource
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        return nameArr.count
    }
    
    func title(inSection section: Int, index: Int) -> String! {
        return nameArr[index]
    }
    
    func defaultShowSection(_ section: Int) -> Int {
        return 0
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        IPAddr.resignFirstResponder()
        IPPort.resignFirstResponder()
    }
}
