//
//  TestCollectionViewCell.swift
//  Channels
//
//  Created by Ahmed Refaat on 4/16/20.
//  Copyright © 2020 Ibtikar. All rights reserved.
//

import UIKit

class SmallCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var coverBackgroundView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

}

extension SmallCollectionViewCell {
    func configure() {
        
        titleLabel.textColor = UIColor.white
        titleLabel.lineBreakMode = .byWordWrapping
        
        setupView()
    }
    
    func setupView() {
        
        coverBackgroundView.contentMode = .scaleAspectFill
        coverBackgroundView.layer.masksToBounds = true
        coverBackgroundView.layer.cornerRadius = 15

    }
    
    func configure(with media: Movie) {
        titleLabel.text = media.title
        
        if let url = media.coverAsset {
            coverBackgroundView.imageFromServerURL(urlString: url, defaultImage: nil)
        }
        
    }
}
