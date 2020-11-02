//
//  InsetCollectionViewController.swift
//  EUNCAROUSEL
//
//  Created by 60080252 on 2020/10/29.
//

import UIKit

class InsetCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellSize = CGSize(width: 300, height: 200)
    let minItemSpacing: CGFloat = 20
    var insetSpacing: CGFloat {
        return (collectionView.bounds.width - cellSize.width) / 2.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }
    
    func setUpCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false
    }
    
}

extension InsetCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ColorImg.colorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = UIImage(named: ColorImg.colorList[indexPath.row].img)
        
        return cell
    }
}

extension InsetCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: insetSpacing, bottom: 0, right: insetSpacing)
    }
}

extension InsetCollectionViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let cellWithSpacingWidth =  cellSize.width + minItemSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWithSpacingWidth
        let roundedIndex: CGFloat = round(index)

        offset = CGPoint(x: roundedIndex * cellWithSpacingWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
