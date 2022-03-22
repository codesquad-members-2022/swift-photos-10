//
//  ViewController.swift
//  PhotoAlbumApp
//
//  Created by Joobang Lee on 2022/03/22.
//

import UIKit

class ViewController: UIViewController {
    private let reusableCellName = "photoItem"
    private let cellCount = 40
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
    }
    
    private func configureCollectionView() {
        self.collectionView.frame = self.view.bounds
        self.collectionView.dataSource = self
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reusableCellName, for: indexPath)
        cell.backgroundColor = .random()
        cell.frame.size = CGSize(width: 80, height: 80)
        
        return cell
    }
}
