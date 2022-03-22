//
//  PhotoFactory.swift
//  PhotoAlbumApp
//
//  Created by 송태환 on 2022/03/22.
//

import Foundation

enum PhotoFactory: FactoryBuildable {
    typealias T = Photo
    
    static func make() -> T {
        let size = Size(width: 80, height: 80)
        return self.make(with: size)
    }
    
    static func make(with size: Size) -> T {
        return Photo(size: size)
    }
}
