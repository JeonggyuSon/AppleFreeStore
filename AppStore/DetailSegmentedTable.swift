//
//  DetailSegmentedTable.swift
//  AppStore
//
//  Created by jgson on 2017. 5. 17..
//  Copyright © 2017년 jgson. All rights reserved.
//

import UIKit

class DetailSegmentedTable: UITableViewController, AddScrollContentSize {

    var appID: String?
    weak var ratingDelegate: AverageUserRatingDelegate?
    weak var iconDelegate: DetailAppIconDelegate?
    
    @IBOutlet weak var summaryCell: ReviewCell!
    @IBOutlet weak var screenshotCell: ReviewCell!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var screenshot: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        let addr = "https://itunes.apple.com/lookup?id=\(appID ?? "")&country=kr"
        
        guard let url = URL(string: addr) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            guard let data = data, error == nil, let detail = self else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                
                let resultsArray = json["results"] as! NSArray
                
                let resultsDic = resultsArray.map { $0 as! [String: Any] }
                let averageUserRating = resultsDic.filter { $0["averageUserRating"] != nil }.map { $0["averageUserRating"] as! CGFloat }
                let summaryText = resultsDic.filter { $0["description"] != nil }.map { $0["description"] as! String }
                let screenshot = resultsDic.filter { $0["screenshotUrls"] != nil }.map { $0["screenshotUrls"] as! NSArray }
                let icon512 = resultsDic.filter { $0["artworkUrl512"] != nil }.map { $0["artworkUrl512"] as! String }
                
                detail.iconDelegate?.setIcon(addr: icon512.first)
                detail.ratingDelegate?.setAverageRating(rating: averageUserRating.first)
                DispatchQueue.main.async {
                    detail.summary.text = summaryText.first
                    screenshot.first!.enumerated().forEach { index, value in
                        let screen = Screenshot(index: CGFloat(index), scrollWidth: detail.screenshot.frame.width)
                        screen.screenshotImageUrl = value as? String
                        screen.delegate = self
                        detail.screenshot.addSubview(screen)
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }).resume()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row{
        case 0:
            return screenshot.frame.maxY + 20
        case 1:
            return summary.sizeThatFits(summary.bounds.size).height + summary.frame.minY + 20
        default:
            return 0
        }
    }
    
    internal func addContent(direction: Bool, size: CGSize) {
        let width = size.width + screenshot.contentSize.width + (direction ? 10 : 0)
        screenshot.contentSize = CGSize(width: width, height: size.height)
        screenshot.frame.size = CGSize(width: screenshot.frame.size.width, height: size.height)
        screenshot.layoutIfNeeded()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
