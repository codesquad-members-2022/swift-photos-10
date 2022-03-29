//
//  MediaCell.swift
//  PhotoAlbumApp
//
//  Created by 송태환 on 2022/03/28.
//

import UIKit

class MediaCell: UICollectionViewCell {
    private let imageView = UIImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    private func configure() {
        self.contentView.addSubview(imageView)
        self.imageView.frame = self.bounds
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight,
            .flexibleTopMargin,
            .flexibleLeftMargin,
            .flexibleRightMargin,
            .flexibleBottomMargin
        ]
    }
    
    func setImage(_ image: UIImage) {
        self.imageView.image = image
    }
}
