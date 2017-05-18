//
//  ViewController.swift
//  AppStore
//
//  Created by jgson on 2017. 5. 16..
//  Copyright © 2017년 jgson. All rights reserved.
//

import UIKit

class FreeAppList: UIViewController {
    
    @IBOutlet weak var freeAppListTable: UITableView!

    var freeList = [CellInfo]() {
        didSet {
            let insertNum = 0..<freeList.count
            let index = insertNum.map { IndexPath(row: $0, section: 0) }
            
            DispatchQueue.main.async {
                self.freeAppListTable.beginUpdates()
                self.freeAppListTable.insertRows(at: index, with: .automatic)
                self.freeAppListTable.endUpdates()
            }
        }
    }
    
    struct CellInfo {
        var iconAddr53: String?
        var iconAddr75: String?
        var iconAddr100: String?
        var appId: String
        var appTitle: String
        
        init(title: String, id: String) {
            appTitle = title
            appId = id
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        freeAppListTable.tableFooterView = UIView()
        
        let addr = "https://itunes.apple.com/kr/rss/topfreeapplications/limit=50/json"
        let url = URL(string: addr)
        URLSession.shared.dataTask(with: url!, completionHandler: { [weak self] (data, response, error) in
            guard let data = data, error == nil, let list = self else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                let feed = json["feed"] as! [String: Any]
                let entry = feed["entry"] as! NSArray
                
                let infos = entry.map { info -> FreeAppList.CellInfo in
                    let json = info as! [String: Any]
                    let imName = json["im:name"] as! [String: Any]
                    let name = imName["label"] as! String
                    
                    let id = json["id"] as! [String: Any]
                    let attr = id["attributes"] as! [String: Any]
                    let imId = attr["im:id"] as! String
                    
                    var cellInfo = CellInfo(title: name, id: imId)
                    
                    let imImage = json["im:image"] as! NSArray
                    
                    imImage.forEach { json in
                        let dic = json as! [String: Any]
                        let attr = dic["attributes"] as! [String: Any]
                        let imgAddr = dic["label"] as! String
                        let height = (attr["height"] as! NSString).intValue
                        
                        switch height {
                        case 53:
                            cellInfo.iconAddr53 = imgAddr
                        case 75:
                            cellInfo.iconAddr75 = imgAddr
                        case 100:
                            cellInfo.iconAddr100 = imgAddr
                        default:
                            return
                        }
                    }
                    
                    return cellInfo
                }
                
                list.freeList.append(contentsOf: infos)
            } catch let error {
                print(error.localizedDescription)
            }
        }).resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension FreeAppList: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return freeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! AppListCell
        let index = freeList[indexPath.row]
        DispatchQueue.main.async {
            cell.appTitle.text = index.appTitle
            cell.rankingNum.text = "\(indexPath.row.hashValue + 1)"
            let url = URL(string: index.iconAddr53!)!
            URLSession.shared.dataTask(with:url, completionHandler: { (data, response, error) in
                guard let httpUrlResponse = response as? HTTPURLResponse else { return}
                if httpUrlResponse.statusCode == 200 {
                    guard let data = data, error == nil else { return }
                    guard let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        cell.iconImg.image = image
                    }
                }
            }).resume()
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "appDetail" {
            let cell = sender as! AppListCell
            let index = freeAppListTable.indexPath(for: cell)!
            let detail = segue.destination as! FreeAppDetail
            let info = freeList[index.row]
            detail.appTitleText = info.appTitle
            detail.iconAddr = info.iconAddr100
            detail.appID = info.appId
        }
    }
}

