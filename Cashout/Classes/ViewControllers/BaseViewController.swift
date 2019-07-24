//
//  BaseViewController.swift
//  Cashout
//


import UIKit

enum LeftButtonType {
    case leftButtonTypeBack
}

class BaseViewController: UIViewController {
    
    var isBtnBackHidden:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        self.setLeftNavigationButtontype()
    }
    
    
    private func setLeftNavigationButtontype () {
        if !isBtnBackHidden {
            let leftButton = UIButton(type: UIButton.ButtonType.system)
            leftButton.addTarget(self, action:#selector(self.leftNavigationAction), for: .touchUpInside)
            leftButton.setImage(#imageLiteral(resourceName: "back"), for: UIControl.State())
            leftButton.tintColor = #colorLiteral(red: 0.1803921569, green: 0.2352941176, blue: 0.3019607843, alpha: 1)
            leftButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            let menuBarButtonItem = UIBarButtonItem(customView: leftButton)
            self.navigationItem.leftBarButtonItems = [menuBarButtonItem]
        }
    }
    
    @objc func leftNavigationAction() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
