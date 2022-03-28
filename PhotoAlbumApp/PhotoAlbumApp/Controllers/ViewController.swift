//
//  ViewController.swift
//  PhotoAlbumApp
//
//  Created by Joobang Lee on 2022/03/22.
//

import UIKit
import Photos

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let imageManager = PHCachingImageManager.default()
    private let reusableCellName = "MediaCell"
    private let album = Album()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestPhotosAccessPermission(completion: self.handlePhotosPermissionResult)
        self.configureCollectionView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Landscape 모드일 때 SafeAreaInset 고려
        let width = view.bounds.inset(by: view.safeAreaInsets).width
        let columnCount = (width / 100).rounded(.towardZero)
        let spacing: CGFloat = 1.2
        
        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.itemSize = CGSize(width: (width / columnCount) - spacing, height: (width / columnCount) - spacing)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
    }
    
    private func fetchImages() {
        let allImagesOptions = PHFetchOptions()
        allImagesOptions.sortDescriptors = [.init(key: "creationDate", ascending: true)]
        
        let assets = PHAsset.fetchAssets(with: .image, options: allImagesOptions)
        
        for i in 0..<assets.count {
            let asset = assets.object(at: i)
            let photo = PhotoFactory.make(id: asset.localIdentifier, with: Size(width: 100, height: 100))
            self.album.append(photo)
        }
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
        case .authorized:
            self.fetchImages()
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reusableCellName, for: indexPath) as? MediaCell else {
            fatalError()
        }
        
        guard let data = self.album[indexPath.row] else {
            return cell
        }

        guard let asset = PHAsset.fetchAssets(withLocalIdentifiers: [data.id], options: PHFetchOptions()).firstObject else { return cell }
        
        imageManager.requestImage(for: asset, targetSize: CGSize(with: data.size), contentMode: .aspectFit, options: nil) { image, data in
            guard let image = image else { return }
            cell.setImage(image)
        }
        
        return cell
    }
}
