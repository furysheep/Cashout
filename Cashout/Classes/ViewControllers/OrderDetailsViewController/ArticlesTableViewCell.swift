//
//  ArticlesTableViewCell.swift
//  Cashout
//

import UIKit

class ArticlesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblArticleName: UILabel!
    @IBOutlet weak var lblArticleDescription: UILabel!
    @IBOutlet weak var lblArticleAmount: UILabel!
    @IBOutlet weak var imgViewIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureItem(item:Item) {
        self.imgViewIcon?.image = #imageLiteral(resourceName: "email")
        self.imgViewIcon = SharedClass.shared.setImageViewTintColor(img: self.imgViewIcon.image!, tintColor: #colorLiteral(red: 0, green: 0.5490196078, blue: 0.2549019608, alpha: 1), imgView: self.imgViewIcon)
        self.lblArticleName.text = "\(item.name)"
        self.lblArticleDescription.text = "\(item.itemDescription)"
        self.lblArticleAmount.text = "€ " + "\(item.price)"
        
    }
    
    func configureTransaction(trans:Transaction) {
        self.imgViewIcon?.image = #imageLiteral(resourceName: "orderOpen")
        self.imgViewIcon = SharedClass.shared.setImageViewTintColor(img: self.imgViewIcon.image!, tintColor: #colorLiteral(red: 0, green: 0.5490196078, blue: 0.2549019608, alpha: 1), imgView: self.imgViewIcon)
        self.lblArticleName.text = "Transaction #"+trans.number
        if trans.transactionType.localized() == "Check".localized() {
            self.lblArticleDescription.text = trans.transactionDate+" - "+trans.transactionType+" "+trans.bank+" #"+trans.chequeNo
        }
        else {
            self.lblArticleDescription.text = trans.transactionDate+" - "+trans.transactionType
        }
        self.lblArticleAmount.text = String(format: "€ %.2f", trans.price)
        
    }
}
