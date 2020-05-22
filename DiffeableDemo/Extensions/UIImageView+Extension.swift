//
//  UIImage+Extension.swift
//  DiffeableDemo
//
//  Created by Ahmed Refaat on 4/20/20.
//  Copyright © 2020 Ibtikar. All rights reserved.
//

import UIKit

extension UIImageView {
public func imageFromServerURL(urlString: String, defaultImage : String?) {
    if let di = defaultImage {
        self.image = UIImage(named: di)
    }

    URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

        if error != nil {
            print(error ?? "error")
            return
        }
        DispatchQueue.main.async(execute: { () -> Void in
            let image = UIImage(data: data!)
            self.image = image
        })

    }).resume()
  }
}
