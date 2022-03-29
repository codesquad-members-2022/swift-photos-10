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
    private var fetchResult: PHFetchResult<PHAsset>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.shared().register(self)
        self.configureCollectionView()
        self.requestPhotosAccessPermission(completion: self.handlePhotosPermissionResult)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
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
        
        self.fetchResult = assets
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
        return self.fetchResult?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reusableCellName, for: indexPath) as? MediaCell else {
            fatalError()
        }
        
        guard let asset = self.fetchResult?.object(at: indexPath.row) else {
            return cell
        }
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .fast
        
        imageManager.requestImage(for: asset, targetSize: cell.frame.size, contentMode: .aspectFill, options: options) { image, data in
            guard let image = image else { return }
            cell.setImage(image)
        }
        
        return cell
    }
}

extension ViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let fetchResult = self.fetchResult else { return }
        
        DispatchQueue.main.sync {
            guard let changes = changeInstance.changeDetails(for: fetchResult) else { return }
            self.fetchResult = changes.fetchResultAfterChanges
            
            guard changes.hasIncrementalChanges == true else {
                self.collectionView.reloadData()
                return
            }
            
            self.collectionView.performBatchUpdates({
                if let removed = changes.removedIndexes, removed.count > 0 {
                    self.collectionView.deleteItems(at: removed.map { IndexPath(item: $0, section: 0) })
                }
                
                if let inserted = changes.insertedIndexes, inserted.count > 0 {
                    print("inserted", inserted)
                    self.collectionView.insertItems(at: inserted.map { IndexPath(item: $0, section: 0) })
                }
                
                if let changed = changes.changedIndexes, changed.count > 0 {
                    self.collectionView.reloadItems(at: changed.map { IndexPath(item: $0, section: 0) })
                }
                
                changes.enumerateMoves { fromIndex, toIndex in
                    self.collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                            to: IndexPath(item: toIndex, section: 0))
                }
            })
        }
    }
}
