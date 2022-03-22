//
//  Album.swift
//  PhotoAlbumApp
//
//  Created by 송태환 on 2022/03/22.
//

import Foundation

class Album {
    private var contents = [MediaContentContainable]()
    private var cache = Set<ObjectIdentifier>()
    
    subscript(index: Int) -> MediaContentContainable? {
        guard index > contents.startIndex && index < contents.endIndex else {
            return nil
        }
        
        return contents[index]
    }
    
    func append(_ item: MediaContentContainable) {
        let id = ObjectIdentifier(item)
        
        guard !self.cache.contains(id) else { return }
        
        self.cache.update(with: id)
        self.contents.append(item)
    }
}
