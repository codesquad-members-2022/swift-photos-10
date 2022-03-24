//
//  ViewController.swift
//  PhotoAlbumApp
//
//  Created by Joobang Lee on 2022/03/22.
//

import UIKit

class ViewController: UIViewController {
    private let reusableCellName = "MediaCell"
    private let cellCount = 40
    private let album = Album()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCellData()
        self.configureCollectionView()
    }
    
    private func loadCellData() {
        for _ in 0..<self.cellCount {
            let data = PhotoFactory.make()
            self.album.append(data)
        }
    }
    
    private func configureCollectionView() {
        self.collectionView.frame = self.view.bounds
        self.collectionView.dataSource = self
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.album.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reusableCellName, for: indexPath)

        guard let data = self.album[indexPath.row] else {
            return cell
        }
        
        cell.frame.size = CGSize(with: data.size)
        cell.backgroundColor = .random()
        
        return cell
    }
}
