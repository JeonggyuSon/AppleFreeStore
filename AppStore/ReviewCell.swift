//
//  ReviewCell.swift
//  AppStore
//
//  Created by jgson on 2017. 5. 16..
//  Copyright © 2017년 jgson. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var writer: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var rating: UserRating!
}
