//
//  MediaContentContainable.swift
//  PhotoAlbumApp
//
//  Created by 송태환 on 2022/03/22.
//

import Foundation

protocol MediaContentContainable: AnyObject {
    var id: String { get }
    var size: Size { get }
}
