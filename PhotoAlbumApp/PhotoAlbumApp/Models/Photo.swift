//
//  Photo.swift
//  PhotoAlbumApp
//
//  Created by 송태환 on 2022/03/22.
//

import Foundation

class Photo: MediaContentContainable {
    let size: Size
    
    // MARK: - 생성자
    init(width: Double, height: Double) {
        self.size = Size(width: width, height: height)
    }
    
    init(size: Size) {
        self.size = size
    }
}
