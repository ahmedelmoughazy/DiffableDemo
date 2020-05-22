//
//  CategoryCollectionViewCell.swift
//  Channels
//
//  Created by Ahmed Refaat on 4/15/20.
//  Copyright © 2020 Ibtikar. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

}

extension CategoryCollectionViewCell {

    func configure() {
        self.layer.cornerRadius = self.frame.height / 2
        titleLabel.textColor = UIColor.white
    }
    
    func configure(with categorey: Categorey) {
        titleLabel.text = categorey.name
    }
}
