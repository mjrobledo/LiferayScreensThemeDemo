//
//  TextFielIcon.swift
//  CMillonario
//
//  Created by DESAPP-1 on 28/12/16.
//  Copyright © 2016 Usuario Lisyx. All rights reserved.
//

import UIKit

class BottomLine: UITextField {
    
    //@IBInspectable var inset: CGFloat = 0
    @IBInspectable var estiloLinea: Bool = false
    
    
        @IBInspectable var colorLineaBottom: UIColor  {
        get {
            return UIColor.white
        }
        set {
            if !estiloLinea == true {
                self.borderStyle = UITextBorderStyle.none
                self.backgroundColor = UIColor.clear
                let width = 1.0
                
                let borderLine = UIView()
                borderLine.frame = CGRect(x: 3, y: Double(self.frame.height) - width, width: Double(self.frame.width)-6, height: width)
                
                borderLine.backgroundColor = newValue
                self.addSubview(borderLine)
            }
        }
    }
     
}
