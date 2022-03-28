//
//  Photo.swift
//  PhotoAlbumApp
//
//  Created by 송태환 on 2022/03/22.
//

import Foundation

class Photo: MediaContentContainable {
    let id: String
    let size: Size
    
    // MARK: - 생성자
    init(id: String, width: Double, height: Double) {
        self.id = id
        self.size = Size(width: width, height: height)
    }
    
    init(id: String, size: Size) {
        self.id = id
        self.size = size
    }
}
