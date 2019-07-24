//
//  CustomerTableViewCell.swift
//  Cashout
//


import UIKit

class CustomerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgViewCustomers: UIImageView!
    @IBOutlet weak var lblCustomersName: UILabel!
    @IBOutlet weak var imgViewNewOrder: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgViewNewOrder = SharedClass.shared.setImageViewTintColor(img: #imageLiteral(resourceName: "dot"), tintColor: #colorLiteral(red: 0, green: 0.5490196078, blue: 0.2549019608, alpha: 1), imgView: imgViewNewOrder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(client:Customer) {
        self.imgViewCustomers.image = #imageLiteral(resourceName: "dummy")
        //        self.imgViewCustomers.fetchImage(strUrl:"https://c.pxhere.com/photos/cc/a4/paramedics_doll_hospital_medical_doll_emergency_paramedic_health_dummy-832318.jpg!d")
        //        self.lblCustomersName.text = "\(client.firstName) \(client.lastName)"
        self.lblCustomersName.text = "\(client.companyName)"
        
        //        if (newOrder){
        //            imgViewNewOrder.isHidden=false
        //        }
        //        else{
        imgViewNewOrder.isHidden=true
        //        }
    }
}
