//
//  CustomCollectionViewCell.swift
//  WaterfallSwiftDemo
//
//  Created by liyang@l2cplat.com on 16/6/16.
//  Copyright © 2016年 yang_li828@163.com. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func refreshCellWithModle(model:CellModel) {
        
        imgView.image = model.smallImage
        
        infoLabel.text = model.name
        
    }

}
