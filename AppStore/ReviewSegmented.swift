//
//  ReviewSegmented.swift
//  AppStore
//
//  Created by jgson on 2017. 5. 16..
//  Copyright © 2017년 jgson. All rights reserved.
//

import UIKit

class ReviewSegmented: UIViewController {
    
    @IBOutlet weak var reviewTable: UITableView!
    var reviews = [ReviewInfo]()
    var appID: String?
    
    struct ReviewInfo {
        var title: String
        var content: String
        var writer: String
        var rating: CGFloat
        
        init(title: NSString, content: NSString, writer: NSString, rating: NSString) {
            self.title = String(title)
            self.content = String(content)
            self.writer = String(writer)
            self.rating = CGFloat(rating.floatValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewTable.rowHeight = UITableViewAutomaticDimension
        reviewTable.estimatedRowHeight = 300
        
        let addr = "https://itunes.apple.com/kr/rss/customerreviews/id=\(appID ?? "")/json"
        let url = URL(string: addr)
        URLSession.shared.dataTask(with: url!, completionHandler: { [weak self] (data, response, error) in
            guard let data = data, error == nil, let review = self else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                let feed = json["feed"] as! [String: Any]
                let reviewArray = feed["entry"] as! NSArray
                
                let reviewDicArray = reviewArray.map { $0 as! [String: Any] }
                let reviewInfos = reviewDicArray.filter { $0["author"] != nil }
                
                reviewInfos.forEach { value in
                    let author = value["author"] as! [String: Any]
                    let name = author["name"] as! [String: Any]
                    let nameLabel = name["label"] as! NSString
                    
                    let rating = value["im:rating"] as! [String: Any]
                    let ratingLabel = rating["label"] as! NSString
                    
                    let title = value["title"] as! [String: Any]
                    let titleLabel = title["label"] as! NSString
                    
                    let content = value["content"] as! [String: Any]
                    let contentLabel = content["label"] as! NSString
                    
                    review.reviews.append(ReviewInfo(title: titleLabel, content: contentLabel, writer: nameLabel, rating: ratingLabel))
                }
                
                DispatchQueue.main.async {
                    review.reviewTable.reloadData()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }).resume()
        
        reviewTable.setNeedsLayout()
        reviewTable.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension ReviewSegmented: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewCell
        let review = reviews[indexPath.row]
        
        cell.title.text = review.title
        cell.content.text = review.content
        cell.writer.text = review.writer
        cell.rating.rating = review.rating
        cell.rating.setNeedsDisplay()
        
        return cell
    }
}
