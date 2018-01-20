//
//  mainScreenViewController.swift
//  TwoWayScroll
//
//  Created by omar arenas landgrave on 1/19/18.
//  Copyright © 2018 om. All rights reserved.
//

import UIKit
import Photos

class mainScreenViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , PHPhotoLibraryChangeObserver {

    @IBOutlet weak var Maintable: UITableView!
    var photoCollection = [String : PHFetchResult<PHAsset>]()
    var headerTitles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Maintable.dataSource = self
        Maintable.register(UINib(nibName: "PhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "Photo")
        Maintable.rowHeight = 120.0
        Maintable.delegate = self
        
        switch PHPhotoLibrary.authorizationStatus() {
            case PHAuthorizationStatus.notDetermined:
                    PHPhotoLibrary.shared().register(self)
            case PHAuthorizationStatus.restricted:
                    print("auth the user")
            case PHAuthorizationStatus.denied:
                    print("nod user")
            case PHAuthorizationStatus.authorized:
                    self.getAlbums()
        }
        
    }
    
    func getAlbums() -> Void {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "estimatedAssetCount > 0")
        let albums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        albums.enumerateObjects { (object, index, stop) in
            let fetchHere = PHFetchOptions()
            fetchHere.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: false)]
            fetchHere.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            let assets = PHAsset.fetchAssets(in: albums[index], options: fetchHere)
            self.photoCollection[object.localizedTitle!] = assets
            self.headerTitles.append(object.localizedTitle!)
            DispatchQueue.main.async {
                self.Maintable.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
}

extension mainScreenViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1 //(self.photoCollection[self.headerTitle[section]]?.count)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.headerTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.headerTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Photo", for: indexPath) as! PhotoTableViewCell
        cell.assestsPHFetchResult = [self.photoCollection[self.headerTitles[indexPath.section]]]
        cell.setPhotoAlbumg()
        return cell
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange){
        
        DispatchQueue.main.async {
            self.getAlbums()
        }
        
    }
}
