//
//  PhotoTableViewCell.swift
//  TwoWayScroll
//
//  Created by omar arenas landgrave on 1/19/18.
//  Copyright © 2018 om. All rights reserved.
//

import UIKit
import Photos

class PhotoTableViewCell: UITableViewCell , UICollectionViewDataSource{

    var options = PHImageRequestOptions()
    var assestsPHFetchResult = [PHFetchResult<PHAsset>?]()
    var assestToFilter = [PHAsset]()
    @IBOutlet weak var PhotoCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        PhotoCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        PhotoCollection.dataSource = self
        let flow = UICollectionViewFlowLayout.init()
        flow.itemSize = CGSize.init(width: 100, height: 100)
        flow.scrollDirection = UICollectionViewScrollDirection.horizontal
        PhotoCollection.collectionViewLayout = flow
        options.version = .original
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setPhotoAlbumg() -> Void {
        
        for index in 0 ... (assestsPHFetchResult.count)-1 {
            
            self.assestsPHFetchResult[index]?.enumerateObjects {(object, count, stop ) in
                self.assestToFilter.append(object)
            }
        }
        
    }
    
}

extension PhotoTableViewCell{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assestToFilter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        let ima = UIImageView()
        ima.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(ima)
        cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[ImageViewPh]|", options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics: nil, views: ["ImageViewPh" : ima]))
        cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[ImageViewPh]|", options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics: nil, views: ["ImageViewPh" : ima]))
        PHImageManager.default().requestImage(for: assestToFilter[indexPath.row], targetSize: cell.frame.size, contentMode: .aspectFit, options: options, resultHandler:{ image, info in
            
            DispatchQueue.main.async {
                ima.image = image
            }
        })
        return cell
    }
    
}
