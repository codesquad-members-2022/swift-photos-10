//
//  CGSize+Extensions.swift
//  PhotoAlbumApp
//
//  Created by 송태환 on 2022/03/22.
//

import UIKit

extension CGSize {
    init(with size:  Size) {
        self.init(width: size.width, height: size.height)
    }
}
