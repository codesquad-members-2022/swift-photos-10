//
//  PhotoAlbumAppTests.swift
//  PhotoAlbumAppTests
//
//  Created by Joobang Lee on 2022/03/23.
//

import XCTest
@testable import PhotoAlbumApp

class PhotoAlbumAppTests: XCTestCase {
    func testAlbum(){
        let album = Album()
        let size = Size(width: 80, height: 80)
        let photo = Photo(size: size)
        album.append(photo)
        XCTAssertEqual(album.count, 1, "True")
    }
    
    func testSize(){
        let size = Size(width: 80, height: 80)
        XCTAssertEqual(size.width, 80.0)
        XCTAssertEqual(size.height, 80.0)
    }
    
    func testPhoto(){
        let size = Size.init(width: 80.0, height: 80.0)
        let photo1 = Photo(width: 80.0, height: 80.0)
        let photo2 = Photo(size: size)
        XCTAssertEqual(photo1.size.width, photo2.size.width)
        XCTAssertEqual(photo2.size.height, photo2.size.height)
    }
    
    func testPhotoFactory(){
        let size = Size(width: 80.0, height: 80.0)
        let photoFactory1 = PhotoFactory.make(with: size)
        let photoFactory2 = PhotoFactory.make()
        XCTAssertEqual(photoFactory1.size.width, photoFactory2.size.width)
        XCTAssertEqual(photoFactory1.size.height, photoFactory2.size.height)
    }
    
    func testCGSize(){
        let size = Size(width: 80.0, height: 80.0)
        let cgsize = CGSize.init(with: size)
        XCTAssertEqual(size.width, cgsize.width)
        XCTAssertEqual(size.height, cgsize.height)
    }
}
