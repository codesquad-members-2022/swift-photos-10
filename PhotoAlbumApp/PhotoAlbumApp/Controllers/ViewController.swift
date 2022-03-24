//
//  ViewController.swift
//  PhotoAlbumApp
//
//  Created by Joobang Lee on 2022/03/22.
//

import UIKit
import Photos

class ViewController: UIViewController {
    private let reusableCellName = "MediaCell"
    private let cellCount = 40
    private let album = Album()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCellData()
        self.configureCollectionView()
        self.requestPhotosAccessPermission(completion: self.handlePhotosPermissionResult)
    }
    
    private func requestPhotosAccessPermission(completion: @escaping (PHAuthorizationStatus) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        guard status != .authorized else {
            completion(status)
            return
        }
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                completion(status)
            }
        }
    }
    
    private func handlePhotosPermissionResult(status: PHAuthorizationStatus) {
        switch status {
        case .notDetermined:
            self.requestPhotosAccessPermission(completion: self.handlePhotosPermissionResult(status:))
        case .denied:
            self.showPermissionDeniedAlert()
        default:
            return
        }
    }
    
    private func showPermissionDeniedAlert() {
        let alert = UIAlertController(title: "사진 권한", message: "사진첩 접근 권한이 필요합니다.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let goToSetting = UIAlertAction(title: "설정으로 가기", style: .default) { action in
            guard let settingUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            guard UIApplication.shared.canOpenURL(settingUrl) else { return }
            
            UIApplication.shared.open(settingUrl)
        }
        
        alert.addAction(cancel)
        alert.addAction(goToSetting)
        
        self.present(alert, animated: true, completion: nil)
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
