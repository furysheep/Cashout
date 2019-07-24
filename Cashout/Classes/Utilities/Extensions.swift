//
//  Extensions.swift
//  Cashout
//


import Foundation
import UIKit
//import Kingfisher

// MARK: Localized String
extension String {
    func localized()-> String{
        return NSLocalizedString(self, comment: "")
    }
}

extension UIView {
    //    var parentViewController: UIViewController? {
    //        var parentResponder: UIResponder? = self
    //        while parentResponder != nil {
    //            parentResponder = parentResponder!.next
    //            if let viewController = parentResponder as? UIViewController {
    //                return viewController
    //            }
    //        }
    //        return nil
    //    }
    
    func dropShadow(color: UIColor, offset: CGSize = CGSize(width:0.0,height: 0.0), radius: CGFloat = 2.0, opacity: Float = 0.2) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false;
    }
    
    ////
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 2
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func addshadow(top: Bool,
                   left: Bool,
                   bottom: Bool,
                   right: Bool,
                   shadowRadius: CGFloat = 1.0) {
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.75
        
        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.bounds.size.width
        var viewHeight = self.bounds.size.height
        
        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y+=(shadowRadius+1)
        }
        if (!bottom) {
            viewHeight-=(shadowRadius+1)
        }
        if (!left) {
            x+=(shadowRadius+1)
        }
        if (!right) {
            viewWidth-=(shadowRadius+1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
    }
    
    @IBInspectable var borderWidth : CGFloat {
        get{
            return layer.borderWidth
        }
        set{
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat {
        get{
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderColor : UIColor? {
        get{
            guard let color = layer.borderColor else { return nil }
            return UIColor.init(cgColor: color)
        }
        set{
            layer.borderColor = newValue?.cgColor
        }
    }
    
}

extension UIImageView {
//    func fetchImage(strUrl:String) {
//        let url = URL(string: strUrl)
//        //self.kf.indicatorType = .activity
//        let processor = RoundCornerImageProcessor(cornerRadius: 260)
//        self.kf.setImage (with: url,placeholder: #imageLiteral(resourceName: "cashout") ,options: [.processor(processor),.memoryCacheExpiration(.never)])
//    }
    
}

extension UITextField {
    
    func setIconWithTint(_ image: UIImage, tintColor:UIColor!) {
        var iconView = UIImageView(frame:
            CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        if (tintColor != nil) {
            iconView = SharedClass.shared.setImageViewTintColor(img: image, tintColor: tintColor, imgView: iconView)
        }
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 40, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
    
    //set Padding
    //    func setPadding () {
    //    let rect = CGRect(x: 0, y: 0, width: (self.leftView.frame.origin.x+self.leftView.frame.size.width+5), height:self.frame.height)
    //    let paddingView = UIView(frame: rect)
    //    txtFieldEmail.leftView = paddingView
    //    }
    
}
