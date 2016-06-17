//
//  ViewController.swift
//  WaterfallSwiftDemo
//
//  Created by liyang@l2cplat.com on 16/6/16.
//  Copyright © 2016年 yang_li828@163.com. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    var collectionView:UICollectionView?
    
    var layout:WaterfallLayout?
    
    var allPhotos:PHFetchResult?
    
    var photoManager:PHCachingImageManager?
    
    var datasource = [CellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI() //初始化界面

        
        setData() //初始化数据
        
    }
    
    func setData() {
        
        let options = PHFetchOptions()
        // 按图片生成时间排序
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        allPhotos = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: options)
        
        photoManager = PHCachingImageManager()
        
        allPhotos?.enumerateObjectsUsingBlock({ (object:AnyObject!, count:Int, stop:UnsafeMutablePointer<ObjCBool>) in
            
            if object is PHAsset{
                
                let asset = object as! PHAsset
                
                let model = CellModel()
                
                model.image = asset
                
                model.w = CGFloat(asset.pixelWidth)
                
                model.h = CGFloat(asset.pixelHeight)
                
                let dateFormatter = NSDateFormatter()
                
                dateFormatter.dateFormat = "MM-dd-yyyy"
                
                model.name = dateFormatter.stringFromDate(asset.modificationDate!)
                
                let itemW = (self.collectionView?.frame.width)! / (self.layout?.columnCount)!
                
                let itemH = itemW * (CGFloat(asset.pixelHeight)/CGFloat(asset.pixelWidth))
                
                let imageSize = CGSize(width: itemW,
                    height: itemH)
                
                /* For faster performance, and maybe degraded image */
                let options = PHImageRequestOptions()
                
                options.deliveryMode = .FastFormat
                
                options.synchronous = true
                
                self.photoManager?.requestImageForAsset(asset, targetSize: imageSize, contentMode: PHImageContentMode.AspectFit, options: options, resultHandler: { (image, info) in
                    
                    model.smallImage = image!
                    
                    self.datasource.append(model)
                    
                    print(model.name)
                    
                })
            }
            
        })
        
    }

    func createUI() {
        

        
        
        //初始化colletionView
        
        layout = WaterfallLayout()
        
        collectionView = UICollectionView(frame:self.view.bounds, collectionViewLayout: layout!)
        
        collectionView?.backgroundColor = UIColor.whiteColor()
        
        collectionView?.registerNib(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        
        collectionView?.dataSource = self

        layout!.columnCount = 3
        
        layout!.columnMargin = 10
        
        layout!.rowMargin = 10
        
        layout!.edge = UIEdgeInsetsMake(10, 10, 10, 10)
        
        layout?.delegate = self
        
        self.view.addSubview(collectionView!)
        
        
        
    }
    
    
}

extension ViewController:UICollectionViewDataSource
{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.datasource.count
    }
    

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        let cell = (collectionView.dequeueReusableCellWithReuseIdentifier("CustomCollectionViewCell", forIndexPath: indexPath) as! CustomCollectionViewCell)
        
        cell.refreshCellWithModle(self.datasource[indexPath.row])
        
        return cell
    }


}

extension ViewController:WaterfallLayoutdelegate
{

    func waterlayout(layout:WaterfallLayout,index:NSInteger,itemWidth:CGFloat) -> CGFloat
    {
        
        
        let model = self.datasource[index]
        
        return  itemWidth*model.h/model.w
        
    }

}


