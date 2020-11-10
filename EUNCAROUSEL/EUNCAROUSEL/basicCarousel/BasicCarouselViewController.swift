//
//  BasicCarouselViewController.swift
//  EUNCAROUSEL
//
//  Created by 60080252 on 2020/11/05.
//

import UIKit

class BasicCarouselViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellSize = CGSize(width: 300, height: 200)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    func configureCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.decelerationRate = .fast
    }
}

extension BasicCarouselViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ColorImg.colorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = UIImage(named: ColorImg.colorList[indexPath.row % ColorImg.colorList.count].img)
        
        return cell
    }
}


extension BasicCarouselViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWithSpacingWidth =  cellSize.width
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWithSpacingWidth
        let roundedIndex: CGFloat = round(index)

        offset = CGPoint(x: roundedIndex * cellWithSpacingWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
