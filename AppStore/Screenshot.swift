//
//  Screenshot.swift
//  AppStore
//
//  Created by jgson on 2017. 5. 17..
//  Copyright © 2017년 jgson. All rights reserved.
//

import UIKit

protocol AddScrollContentSize: class {
    func addContent(size: CGSize)
}

class Screenshot: UIImageView {
    weak var delegate: AddScrollContentSize?
    var index: CGFloat?
    var screenshotImageUrl: String? {
        didSet {
            let url = URL(string: screenshotImageUrl!)!
            URLSession.shared.dataTask(with:url, completionHandler: { [weak self] (data, response, error) in
                guard let imageView = self else { return }
                guard let httpUrlResponse = response as? HTTPURLResponse else { return}
                
                if httpUrlResponse.statusCode == 200 {
                    guard let data = data, error == nil else { return }
                    guard let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        let imgSize = CGSize(width: image.size.width / 2, height: image.size.height / 2)
                        imageView.frame = CGRect(x: (imageView.index! * image.size.width / 2) + (imageView.index! * 10), y: 0, width: imgSize.width, height: imgSize.height)
                        imageView.image = image
                        imageView.delegate?.addContent(size: imgSize)
                    }
                }
            }).resume()
        }
    }
    
    convenience init(index: CGFloat) {
        self.init()
        self.index = index
    }
}
