//
//  ReviewSegmented.swift
//  AppStore
//
//  Created by jgson on 2017. 5. 16..
//  Copyright © 2017년 jgson. All rights reserved.
//

import UIKit

class ReviewSegmented: UIViewController {

    var reviews = [ReviewInfo]()
    var appID: String?
    
    struct ReviewInfo {
        var title: String
        var writer: String
        var rating: String
        
        init(title: String, writer: String, rating: String) {
            self.title = title
            self.writer = writer
            self.rating = rating
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addr = "https://itunes.apple.com/rss/customerreviews/id=\(appID ?? "")/json"
        let url = URL(string: addr)
        URLSession.shared.dataTask(with: url!, completionHandler: { [weak self] (data, response, error) in
            guard let data = data, error == nil, let review = self else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                
                print("\(json)")
            } catch let error {
                print(error.localizedDescription)
            }
        }).resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension ReviewSegmented: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewCell
//        
//        DispatchQueue.main.async {
//            cell.appTitle.text = index.appTitle
//            cell.rankingNum.text = "\(indexPath.row.hashValue + 1)"
//            let url = URL(string: index.iconAddr53!)!
//            URLSession.shared.dataTask(with:url, completionHandler: { (data, response, error) in
//                guard let httpUrlResponse = response as? HTTPURLResponse else { return}
//                if httpUrlResponse.statusCode == 200 {
//                    guard let data = data, error == nil else { return }
//                    guard let image = UIImage(data: data) else { return }
//                    DispatchQueue.main.async {
//                        cell.iconImg.image = image
//                    }
//                }
//            }).resume()
//        }
        
        return cell
    }
}
