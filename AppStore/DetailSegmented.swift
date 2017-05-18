//
//  DetailSegmented.swift
//  AppStore
//
//  Created by jgson on 2017. 5. 16..
//  Copyright © 2017년 jgson. All rights reserved.
//

import UIKit

class DetailSegmented: UIViewController {

    @IBOutlet weak var detailScrollView: UIScrollView!
    var appID: String?
    
    lazy var screenshotScrollView: UIScrollView = { [unowned self] in
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addr = "https://itunes.apple.com/lookup?id=\(appID ?? "")&country=kr"
        let url = URL(string: addr)
        URLSession.shared.dataTask(with: url!, completionHandler: { [weak self] (data, response, error) in
            guard let data = data, error == nil, let detail = self else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                
                let resultsArray = json["results"] as! NSArray
                
                print("\(resultsArray)")
            } catch let error {
                print(error.localizedDescription)
            }
        }).resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
