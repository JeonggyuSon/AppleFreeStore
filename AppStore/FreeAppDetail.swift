//
//  FreeAppDetail.swift
//  AppStore
//
//  Created by jgson on 2017. 5. 16..
//  Copyright © 2017년 jgson. All rights reserved.
//

import UIKit

protocol AverageUserRatingDelegate: class {
    func setAverageRating(rating: CGFloat?)
}

protocol DetailAppIconDelegate: class {
    func setIcon(addr: String?)
}

class FreeAppDetail: UIViewController, AverageUserRatingDelegate, DetailAppIconDelegate {
    
    @IBOutlet weak var reviewSegmented: UIView!
    @IBOutlet weak var detailSegmented: UIView!
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var iconImg: UIImageView! {
        didSet {
            iconImg.layer.borderWidth = 0.5
            iconImg.layer.borderColor = UIColor.lightGray.cgColor
            iconImg.layer.cornerRadius = 15
        }
    }
    
    @IBOutlet weak var userRating: UserRating!
    var appID: String?
    var appTitleText: String?
    var iconAddr: String? {
        didSet {
            guard let url = URL(string: iconAddr ?? "") else { return }
            URLSession.shared.dataTask(with:url, completionHandler: { [weak self] (data, response, error) in
                guard let detailVC = self else { return }
                guard let httpUrlResponse = response as? HTTPURLResponse else { return}
                if httpUrlResponse.statusCode == 200 {
                    guard let data = data, error == nil else { return }
                    guard let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        detailVC.iconImg.image = image
                    }
                }
            }).resume()
        }
    }
    
    @IBAction func selectSegmented(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            detailSegmented.isHidden = false
            reviewSegmented.isHidden = true
        case 1:
            detailSegmented.isHidden = true
            reviewSegmented.isHidden = false
        default:
            return
        }
    }
    
    internal func setAverageRating(rating: CGFloat?) {
        DispatchQueue.main.async {
            self.userRating.rating = rating!
            self.userRating.setNeedsDisplay()
        }
    }
    
    internal func setIcon(addr: String?) {
        iconAddr = addr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appTitle.text = appTitleText ?? ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let detail = segue.destination as! DetailSegmentedTable
            detail.ratingDelegate = self
            detail.iconDelegate = self
            detail.appID = appID
        } else if segue.identifier == "review" {
            let review = segue.destination as! ReviewSegmented
            review.appID = appID
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
