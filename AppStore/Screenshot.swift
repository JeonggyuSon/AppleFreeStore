//
//  Screenshot.swift
//  AppStore
//
//  Created by jgson on 2017. 5. 17..
//  Copyright © 2017년 jgson. All rights reserved.
//

import UIKit

protocol AddScrollContentSize: class {
    // 가로 : true, 세로 : false
    func addContent(direction: Bool, size: CGSize)
}

class Screenshot: UIImageView {
    weak var delegate: AddScrollContentSize?
    var index: CGFloat = 0
    var scrollWidth: CGFloat = 0
    var screenshotImageUrl: String? {
        didSet {
            guard let url = URL(string: screenshotImageUrl ?? "") else { return }
            URLSession.shared.dataTask(with:url, completionHandler: { [weak self] (data, response, error) in
                guard let imageView = self else { return }
                guard let httpUrlResponse = response as? HTTPURLResponse else { return}
                
                if httpUrlResponse.statusCode == 200 {
                    guard let data = data, error == nil else { return }
                    guard let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        if image.size.width > image.size.height {
                            // 가로 이미지
                            let height = ( imageView.scrollWidth / image.size.width ) * image.size.height
                            let resize = CGSize(width: imageView.scrollWidth, height: height)
                            imageView.frame = CGRect(x: (imageView.index * imageView.scrollWidth), y: 0, width: resize.width, height: resize.height)
                            imageView.delegate?.addContent(direction: false, size: resize)
                        } else {
                            // 세로 이미지
                            let imgSize = CGSize(width: image.size.width / 2, height: image.size.height / 2)
                            imageView.frame = CGRect(x: (imageView.index * image.size.width / 2) + (imageView.index * 10), y: 0, width: imgSize.width, height: imgSize.height)
                            imageView.delegate?.addContent(direction: true, size: imgSize)
                        }
                        imageView.image = image
                    }
                }
            }).resume()
        }
    }
    
    convenience init(index: CGFloat, scrollWidth: CGFloat) {
        self.init()
        self.index = index
        self.scrollWidth = scrollWidth
    }
}
