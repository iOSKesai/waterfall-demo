//
//  WaterfallLayout.swift
//  WaterfallSwiftDemo
//
//  Created by liyang@l2cplat.com on 16/6/16.
//  Copyright © 2016年 yang_li828@163.com. All rights reserved.
//

import UIKit

protocol WaterfallLayoutdelegate:NSObjectProtocol {
    
    //代理方法 返回item的高度
    func waterlayout(layout:WaterfallLayout,index:NSInteger,itemWidth:CGFloat) -> CGFloat
    
}

class WaterfallLayout: UICollectionViewLayout {
    
    var columnMargin:CGFloat?  //列间距
   
    var rowMargin:CGFloat?  //行间距
    
    var columnCount:CGFloat? //列数
    
    var edge:UIEdgeInsets?
    
    var attributesArray:Array<UICollectionViewLayoutAttributes> = []
    
    var allColumnMaxYArray:Array<CGFloat> = []
    
    var contentSizeHeight:CGFloat = 0   //内容的高度

    weak var delegate: WaterfallLayoutdelegate?
    
    override func prepareLayout() {
        
        super.prepareLayout()
        
        self.contentSizeHeight = 0
        
        //先清空数组
        
        allColumnMaxYArray.removeAll()
        
        let count:Int = Int(self.columnCount!)
        
        for _ in 0..<count {
            
            allColumnMaxYArray.append((self.edge?.top)!)
        }
        
        //开始创建每一个cell对应的布局属性
        //一共有多少个cell
        
        let cellCount = self.collectionView?.numberOfItemsInSection(0)
        
        for i in 0..<cellCount! {
            
            //获取i位置上的索引
            let IndexPath = NSIndexPath(forItem: i, inSection: 0)
            
            //获取每个cell的布局属性
            let attributes = self.layoutAttributesForItemAtIndexPath(IndexPath)
            
            attributesArray.append(attributes)
            
            print(i)
            
        }

        
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        
        return attributesArray
    }
    
    //为了只能上下滑动，不能左右滑动
    override func collectionViewContentSize() -> CGSize {
        
        return CGSizeMake(0, self.contentSizeHeight+self.edge!.bottom)
        
    }
    
    
    override func layoutAttributesForItemAtIndexPath(indexPath:NSIndexPath) -> UICollectionViewLayoutAttributes {
        
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        //collectionViewW
        let collectionViewW = self.collectionView!.frame.size.width
        
        //找出高度最短的那一列
        var column = 0
        
        //默认第一列的高度最短
        var minColumnHeight = self.allColumnMaxYArray[0]
        
        
        //遍历数组所有值
        
        for i in 1..<Int(self.columnCount!)
        {
            
            let columnHeight = CGFloat(self.allColumnMaxYArray[i])
            
            //判断高度
            if minColumnHeight>columnHeight
            {
                
                minColumnHeight = columnHeight;
                
                column = i;

            }
        }
        
        //设置布局
        let w = (collectionViewW - (self.edge?.left)! - (self.edge?.right)! - (self.columnCount!-1)*(self.columnMargin)!)/self.columnCount!
        
        let x = (self.edge?.left)! + CGFloat(column) * (w + (self.columnMargin)!)
        
        var y = minColumnHeight
        
        //如果不是第一行时
        if y != (self.edge?.top)!
        {
            y += self.rowMargin!
        }
        
        let h  = self.delegate!.waterlayout(self, index: indexPath.row, itemWidth: w)
        
        //设置frame
        attributes.frame = CGRectMake(x, y, w, h);
        

        //更新最短列的高度
        self.allColumnMaxYArray[column] = CGRectGetMaxY(attributes.frame)
        
        //记录最大高度
        let columHeight = self.allColumnMaxYArray[column]
        
        if self.contentSizeHeight < columHeight
        {
            self.contentSizeHeight = columHeight;

        }
        
        
        return attributes
    }

}
