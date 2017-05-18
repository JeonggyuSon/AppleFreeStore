//
//  UserRating.swift
//  AppStore
//
//  Created by jgson on 2017. 5. 18..
//  Copyright © 2017년 jgson. All rights reserved.
//

import UIKit

@IBDesignable
class UserRating: UIView {

    var rating: CGFloat = 0
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let width = rating / 5 * rect.width
        let color = UIColor.black
        let drect = CGRect(x: 0, y: 0, width: width, height: rect.height)
        let path = UIBezierPath(rect: drect)
        
        color.set()
        path.fill()
        path.close()
    }
}
