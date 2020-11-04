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
    let timeInterval = 5.0
    /**
     - description: 무한 스크롤처럼 보이도록 하기 위해 원래 배열의 count보다 큰 값을 배열의 count로 지정함
     */
    let fakePageCount = ColorImg.colorList.count * 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialPage()
        setUpPageControl()
        setBannerTimer()
    }
    
    func setUpPageControl() {
        pageControl.hidesForSinglePage = true
        pageControl.numberOfPages = ColorImg.colorList.count
    }
    
    func setInitialPage() {
        /**
         - description: 무한 스크롤처럼 보이도록 하기 위해 중간값을 찾아서 초기 cell로 지정함
         */
        let middleIndex = fakePageCount / 2
        collectionView.scrollToItem(at: IndexPath(row: middleIndex, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    func setBannerTimer() {
        let timer = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    @objc func scrollAutomatically() {
        let visibleIndexPaths: IndexPath = collectionView.indexPathsForVisibleItems[0]
        var nextIndex = visibleIndexPaths.row + 1
        if nextIndex >= fakePageCount {
            nextIndex = 0;
        }
        collectionView.scrollToItem(at: IndexPath(row: nextIndex, section: 0), at: .right, animated: true)
    }
}

extension BannerCarouselViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fakePageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = UIImage(named: ColorImg.colorList[indexPath.row % ColorImg.colorList.count].img)
        
        return cell
    }
}

extension BannerCarouselViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row % ColorImg.colorList.count
    }
}
