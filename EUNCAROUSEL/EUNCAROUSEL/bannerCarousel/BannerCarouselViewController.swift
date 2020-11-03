//
//  BannerCarouselViewController.swift
//  EUNCAROUSEL
//
//  Created by 60080252 on 2020/11/03.
//

import UIKit

class BannerCarouselViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    let timeInterval = 3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPageControl()
        bannerTimer()
    }
    
    func setUpPageControl() {
        pageControl.hidesForSinglePage = true
        pageControl.numberOfPages = ColorImg.colorList.count
    }
    
    func bannerTimer() {
        let timer =  Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    @objc func scrollAutomatically() {
        var nextIndex = pageControl.currentPage + 1
        if nextIndex >= ColorImg.colorList.count {
            nextIndex = 0;
        }
        collectionView.scrollToItem(at: IndexPath(row: nextIndex, section: 0), at: .right, animated: true)
    }
}

extension BannerCarouselViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ColorImg.colorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = UIImage(named: ColorImg.colorList[indexPath.row % ColorImg.colorList.count].img)
        
        return cell
    }
}

extension BannerCarouselViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
}
