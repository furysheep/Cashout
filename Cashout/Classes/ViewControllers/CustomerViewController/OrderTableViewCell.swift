//
//  OrderTableViewCell.swift
//  Cashout
//


import UIKit

class OrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgViewOrderType: UIImageView!
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblOrderItemQuantity: UILabel!
    @IBOutlet weak var lblOrderAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(selectedSegment:Int, order:Order) {
        switch selectedSegment {
        case 1:self.imgViewOrderType?.image = #imageLiteral(resourceName: "orderComplete")
        case 2:self.imgViewOrderType?.image = #imageLiteral(resourceName: "orderCancelled")
        default:self.imgViewOrderType?.image = #imageLiteral(resourceName: "orderOpen")
        }
        self.imgViewOrderType = SharedClass.shared.setImageViewTintColor(img: self.imgViewOrderType.image!, tintColor: #colorLiteral(red: 0, green: 0.5490196078, blue: 0.2549019608, alpha: 1), imgView: self.imgViewOrderType)
        self.lblOrderNo.text = String(format: "%@%@", "Order #".localized(),order.number)
        self.lblOrderItemQuantity.text = String(format: "%d %@",order.itemCount,"item".localized())
        self.lblOrderAmount.text = "€ " + "\(order.amount)"
    }
    
    func configure(credit:Credit) {
        self.lblOrderNo.text = String(format: "(%@) - %@ %@", credit.n_doc, credit.name_doc, credit.date_doc_ita)
        self.lblOrderAmount.text = "€ " + "\(credit.avere)"
    }
}
