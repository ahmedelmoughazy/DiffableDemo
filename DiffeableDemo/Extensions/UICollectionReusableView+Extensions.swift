//
//  UICollectionReusableView+Extensions.swift
//  Channels
//
//  Created by Ahmed Refaat on 4/11/20.
//  Copyright © 2020 Ibtikar. All rights reserved.
//

import UIKit

extension UICollectionReusableView {
    static var nibName: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
