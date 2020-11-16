//
//  CollectionViewCellExtension.swift
//  EUNCAROUSEL
//
//  Created by 60080252 on 2020/11/16.
//

import UIKit

extension UICollectionViewCell {
    func setShadow(cornerRadius: CGFloat, shadowRadius: CGFloat, shadowOpacity: Float, shadowOffsetWidth: CGFloat, shadowOffsetHeight: CGFloat) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowPath = UIBezierPath(roundedRect:bounds, cornerRadius:contentView.layer.cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
    }
    
    func setBorderRound(cornerRadius: CGFloat) {
        self.contentView.layer.cornerRadius = cornerRadius
        self.contentView.layer.masksToBounds = true
    }
}
