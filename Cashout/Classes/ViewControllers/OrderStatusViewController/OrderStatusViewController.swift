//
//  OrderStatusViewController.swift
//  Cashout
//

import UIKit

class OrderStatusViewController: BaseViewController {
    
    @IBOutlet weak var imgViewOrderStatus: UIImageView!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblOrderStatusDetail: UILabel!
    @IBOutlet weak var btnPrintBack: UIButton!
    
    enum viewState {
        case transactionCompleted
        case orderCancelled
        case transaction
    }
    var currentUIState:viewState = .transaction
    
    var customerName = ""
    var selectedOrder = Order()
    var selectedTrans = Transaction()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUI()
    }
    
    func setUI () {
        if (self.currentUIState == .transactionCompleted) {
            self.imgViewOrderStatus.image = #imageLiteral(resourceName: "orderStatusCompleted")
            self.lblOrderStatus.text = "Transaction Registered".localized()
            self.lblOrderStatusDetail.text = "A transaction of € ".localized()+"\(self.selectedTrans.price) "+"for".localized()+"\(customerName)"+" has been registered.".localized()
            self.btnPrintBack.setTitle("Print Receipt".localized(), for: UIControl.State.normal)
            self.btnPrintBack.backgroundColor = #colorLiteral(red: 0, green: 0.5490196078, blue: 0.2549019608, alpha: 1)
        }
        else if (self.currentUIState == .orderCancelled) {
            self.imgViewOrderStatus.image = #imageLiteral(resourceName: "orderStatusCancelled")
            self.lblOrderStatus.text = "Order Cancelled".localized()
            self.lblOrderStatusDetail.text = "The order of ".localized()+"\(customerName)"+" of ".localized()+"\(self.selectedOrder.amount) €"+" has been cancelled.".localized()
            self.btnPrintBack.setTitle("Back".localized(), for: UIControl.State.normal)
            self.btnPrintBack.backgroundColor = #colorLiteral(red: 0.1803921569, green: 0.2352941176, blue: 0.3019607843, alpha: 1)
        }
        else {
            self.imgViewOrderStatus.image = #imageLiteral(resourceName: "transaction")
            self.lblOrderStatus.text = String.init(format: "%@%@", "Transaction #".localized(),self.selectedTrans.number)
            self.lblOrderStatusDetail.text = "Transaction for € ".localized()+"\(self.selectedTrans.price) "+self.selectedTrans.transactionDate
            self.btnPrintBack.setTitle("Print Receipt".localized(), for: UIControl.State.normal)
            self.btnPrintBack.backgroundColor = #colorLiteral(red: 0, green: 0.5490196078, blue: 0.2549019608, alpha: 1)
        }
    }
    
    @IBAction func printBackAction(_ sender: Any) {
        if (self.currentUIState == .orderCancelled) {
               self.backAction()
        }
        else {
            let sb = UIStoryboard(name: Constants.StoryBoard.printSB, bundle: nil)
                if let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifier.printViewController) as? PrintViewController {
                    vc.selectedOrder = self.selectedOrder
                    vc.selectedTrans = self.selectedTrans
                    //self.navigationController?.pushViewController(vc, animated: true)
                    self.printRecipt(viewController: vc)
                }

        }
    }
    
    func printRecipt(viewController:UIViewController)
        //    {
        //                    // 1
        //                    let printController = UIPrintInteractionController.shared
        //                    // 2
        //                    let printInfo = UIPrintInfo(dictionary:nil)
        //                    printInfo.outputType = .general
        //                    printInfo.jobName = "print Job"
        //                    printController.printInfo = printInfo
        //
        //                    // 3
        //                    let formatter = UIMarkupTextPrintFormatter(markupText: "textView.text")
        //                    formatter.perPageContentInsets = UIEdgeInsets(top: 72, left: 72, bottom: 72, right: 72)
        //                    printController.printFormatter = formatter
        //
        //                    // 4
        //                    printController.present(animated: true, completionHandler: nil)
        //    }
    {
        
        //guard let path = Bundle.main.url(forResource: "Receipt", withExtension: "pdf") else { return }
        
        let alertController = UIAlertController(title: "Select printer type", message: nil, preferredStyle: .actionSheet)
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = btnPrintBack.frame
        alertController.popoverPresentationController?.permittedArrowDirections = .down
        alertController.addAction(UIAlertAction(title: "AirPrint", style: .default, handler: { (action) in
            self.airPrint(viewController: viewController)
        }))
        alertController.addAction(UIAlertAction(title: "Roll Print", style: .default, handler: { (action) in
            self.regoPrint()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    
    func regoPrint() {
        performSegue(withIdentifier: "showRollPrint", sender: self)
    }
    
    func airPrint(viewController: UIViewController) {
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfo.OutputType.grayscale
        printInfo.jobName = "Order".localized()+" \(self.selectedOrder.number)"
        
        
        // Set up print controller
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        printController.showsPaperSelectionForLoadedPapers = true
        // Assign a UIImage version of my UIView as a printing iten
        printController.printingItem = viewController.view.toImage()
        //printController.printingItem = path
        
        self.navigationController?.navigationBar.isHidden = true
        // Do it
        printController.present(from: CGRect.init(), in: self.view, animated: true) { (UIPrintInteractionController, success, error) in
            if (error != nil) {
                return
            }
            if success {
                print("success print")
            }
            self.navigationController?.navigationBar.isHidden = false
        }
    }
    
    
    
    override func leftNavigationAction() {
       self.backAction()
    }
    
    private func backAction () {
        let array = self.navigationController?.viewControllers
        var vc:UIViewController?
//        if self.currentUIState == .orderCancelled {
            vc = array!.first(where: {
                $0 is CustomerViewController
            })
//        }
//        else {
//            vc = array!.first(where: {
//                $0 is OrderDetailsViewController
//            })
//        }
        self.navigationController?.popToViewController(vc!, animated: true)
    }
    
}

extension UIView {
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
