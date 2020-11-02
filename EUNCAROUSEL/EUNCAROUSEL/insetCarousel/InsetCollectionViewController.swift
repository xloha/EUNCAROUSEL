//
//  InsetCollectionViewController.swift
//  EUNCAROUSEL
//
//  Created by 60080252 on 2020/10/29.
//

import UIKit

class InsetCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let cellSize = CGSize(width: 300, height: 200)
    let minItemSpacing: CGFloat = 10
    var insetSpacing: CGFloat {
        return (collectionView.bounds.width - cellSize.width) / 2.0
    }
    var previousIndex = 0
    var nextIndex = 1
    let initialIndex = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setUpPageControl()
        setUpInitialPage()
    }
    
    func setUpCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false
    }
    
    func animateZoomForCell(zoomCell: UICollectionViewCell) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { zoomCell.transform = .identity }, completion: nil)
    }
    
    func animateZoomForCellRemove(zoomCell: UICollectionViewCell) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { zoomCell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8) }, completion: nil)
    }

    func setUpPageControl() {
        pageControl.hidesForSinglePage = true
        pageControl.numberOfPages = ColorImg.colorList.count
    }
    
    func setUpInitialPage() {
        let indexPath = IndexPath(row: initialIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = indexPath.row
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

extension InsetCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if initialIndex > 0 && indexPath.row == initialIndex - 1 {
            cell.transform = .init(scaleX: 0.8, y: 0.8)
        }
        if indexPath.row == nextIndex {
            cell.transform = .init(scaleX: 0.8, y: 0.8)
        }
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
        
        pageControl.currentPage = Int(roundedIndex)

        offset = CGPoint(x: roundedIndex * cellWithSpacingWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cellWithSpacingWidth =  cellSize.width + minItemSpacing
        let offsetX = collectionView.contentOffset.x
        let index = (offsetX + scrollView.contentInset.left) / cellWithSpacingWidth
        let roundedIndex = Int(round(index))
        let indexPath = IndexPath(row: roundedIndex, section: 0)
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            animateZoomForCell(zoomCell: cell)
        }
        
        if roundedIndex != previousIndex {
            let preIndexPath = IndexPath(row: previousIndex, section: 0)
            if let preCell = collectionView.cellForItem(at: preIndexPath) {
                animateZoomForCellRemove(zoomCell: preCell)
            }
            
            if previousIndex < roundedIndex {
                let nIndex = roundedIndex + 1
                if nIndex < ColorImg.colorList.count {
                    self.nextIndex = nIndex
                }
            } else {
                let nIndex = roundedIndex - 1
                if nIndex >= 0 {
                    self.nextIndex = nIndex
                }
            }
            previousIndex = indexPath.row
        }
    }
}
