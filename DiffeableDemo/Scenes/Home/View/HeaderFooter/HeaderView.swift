//
//  HeaderView.swift
//  Channels
//
//  Created by Ahmed Refaat on 4/11/20.
//  Copyright © 2020 Ibtikar. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        titleLabel.textColor = UIColor.white
        titleLabel.adjustsFontForContentSizeCategory = true
    }
    
    func configureHeader(sectionType: AnyHashable) {
        if let header = sectionType as? MovieSection {
            titleLabel.text = header.sectionTitle
        }
        
        if let header = sectionType as? CategoreySection {
            titleLabel.text = header.sectionTitle
        }
    }
}
