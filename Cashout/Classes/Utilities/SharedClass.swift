//
//  SharedClass.swift
//  Cashout
//


import Foundation
import UIKit

final class SharedClass {
    
    //Shared Instance
    static let shared = SharedClass()
    
    var currentSelectedCustomer = Customer()
    var currentSelectedOrder = Order()
    var currentSelectedTrans = Transaction()
    
    func setImageViewTintColor(img:UIImage, tintColor:UIColor, imgView:UIImageView) -> UIImageView {
        let templateImage = img.withRenderingMode(.alwaysTemplate)
        imgView.image = templateImage
        imgView.tintColor = tintColor
        return imgView
    }
    
    func getFloatToThreeDigitFrom(number:Float) -> Float32 {
        return Float32(round(1000*number)/1000)
    }
    
    func logMsg(_ msg: Any) {
        #if DEBUG
        print("\(msg)")
        #endif
    }
}
