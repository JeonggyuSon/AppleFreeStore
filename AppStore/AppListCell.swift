//
//  AppListCell.swift
//  AppStore
//
//  Created by jgson on 2017. 5. 16..
//  Copyright © 2017년 jgson. All rights reserved.
//

import UIKit

class AppListCell: UITableViewCell {
    @IBOutlet weak var rankingNum: UILabel!
    @IBOutlet weak var iconImg: UIImageView! {
        didSet {
            iconImg.layer.borderWidth = 0.5
            iconImg.layer.borderColor = UIColor.lightGray.cgColor
            iconImg.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var appTitle: UILabel!
}
