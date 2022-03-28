//
//  FactoryBuildable.swift
//  PhotoAlbumApp
//
//  Created by 송태환 on 2022/03/22.
//

import Foundation

protocol FactoryBuildable {
    associatedtype T
    static func make(id: String) -> T
}
