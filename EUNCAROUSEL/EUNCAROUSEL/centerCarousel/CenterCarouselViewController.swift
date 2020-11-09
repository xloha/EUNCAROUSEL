//
//  CenterCarouselViewController.swift
//  EUNCAROUSEL
//
//  Created by jiyoun on 2020/11/04.
//  Ref.https://nsios.tistory.com/45

import UIKit

class CenterCarouselViewController: UIViewController {
	
	@IBOutlet weak var centerCarouselCollectionView: UICollectionView!
	
	var lastContentOffset: CGFloat = 0
	
	var cellSize: CGSize = CGSize(width: 200, height: 250)
	var previousIndex = 0
	var nowIndex = 0
	let minimumSpacing:CGFloat = 20
	
	var idleTimer : Timer?
	var timeoutNumber = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		cellSize.width = centerCarouselCollectionView.frame.width - 120
		cellSize.height = centerCarouselCollectionView.frame.height
		setupCollectionView()
		
	}
	
	
	func setupCollectionView() {
		cellSize.width = (view.frame.width - 2 * minimumSpacing) * 0.5
		
		let insetX = (view.bounds.width - cellSize.width) / 2.0
		
		centerCarouselCollectionView.contentInsetAdjustmentBehavior = .never
		centerCarouselCollectionView.contentInset = UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
		centerCarouselCollectionView.decelerationRate = .fast
	}
	
	func animateZoomforCell(zoomCell: UICollectionViewCell) {
		UIView.animate(
			withDuration: 0.2,
			delay: 0,
			options: .curveEaseOut,
			animations: {
				zoomCell.transform = .identity
				
			},
			completion: nil
		)
		
		
	}
	
	func animateZoomforCellremove(zoomCell: UICollectionViewCell) {
		UIView.animate(
			withDuration: 0.2,
			delay: 0,
			options: .curveEaseOut,
			animations: {
				zoomCell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8) },
			completion: nil
		)
	}
	
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		let cellWidthWithSpacing = cellSize.width + minimumSpacing
		var offset = targetContentOffset.pointee
		let index = (offset.x + scrollView.contentInset.left) / cellWidthWithSpacing
		let roundedIndex:CGFloat = round(index)
		
		offset = CGPoint(x: roundedIndex * cellWidthWithSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
		targetContentOffset.pointee = offset
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let cellWidthIncludeSpacing = cellSize.width + minimumSpacing
		let offsetX = centerCarouselCollectionView.contentOffset.x
		let index = (offsetX + centerCarouselCollectionView.contentInset.left) / cellWidthIncludeSpacing
		let roundedIndex = Int(round(index))
		let indexPath = IndexPath(item: roundedIndex, section: 0)
		
		if let cell = centerCarouselCollectionView.cellForItem(at: indexPath) {
			animateZoomforCell(zoomCell: cell)
			nowIndex = roundedIndex
		}
		let beforeIndexPath = IndexPath(item: roundedIndex - 1, section: 0)
		let afterIndexPath = IndexPath(item: roundedIndex + 1, section: 0)
		
		if roundedIndex != previousIndex {
			let preIndexPath = IndexPath(item: previousIndex, section: 0)
			if let preCell = centerCarouselCollectionView.cellForItem(at: preIndexPath) {
				animateZoomforCellremove(zoomCell: preCell)
			}
			if lastContentOffset > scrollView.contentOffset.x { // move left
				if roundedIndex < 0 {
					if let moveCell = self.centerCarouselCollectionView.cellForItem(at: IndexPath(row: 5, section: 0)) {
						self.animateZoomforCell(zoomCell: moveCell)
						nowIndex = 5
					}
					DispatchQueue.main.async {
						let lastIndex = IndexPath(row: 5, section: 0)
						self.centerCarouselCollectionView.scrollToItem(at: lastIndex, at: .right, animated: true)
					}
				}
			}
			else {
				if roundedIndex > 5 {
					if let moveCell = self.centerCarouselCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) {
						self.animateZoomforCell(zoomCell: moveCell)
						nowIndex = 0
					}
					DispatchQueue.main.async {
						let lastIndex = IndexPath(row: 0, section: 0)
						self.centerCarouselCollectionView.scrollToItem(at: lastIndex, at: .left, animated: true)
					}
				}
			}
			print(beforeIndexPath, afterIndexPath)
			if beforeIndexPath.item != preIndexPath.item, let beforeCell = centerCarouselCollectionView.cellForItem(at: beforeIndexPath) {
				animateZoomforCellremove(zoomCell: beforeCell)
			}
			if afterIndexPath.item != preIndexPath.item, let afterCell = centerCarouselCollectionView.cellForItem(at: afterIndexPath) {
				animateZoomforCellremove(zoomCell: afterCell)
			}
			
		}
		previousIndex = indexPath.item
		lastContentOffset = scrollView.contentOffset.x
	}
	
	func setTimer() {
		if let timer = idleTimer {
			//timer 객체가 nil 이 아닌경우에는 invalid 상태에만 시작한다
			if !timer.isValid {
				idleTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
			}
		}else{
			idleTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
		}
		
	}
	
	func resetTimer() {
		if let timer = idleTimer {
			if(timer.isValid){
				timer.invalidate()
			}
		}
		timeoutNumber = 0
	}
	
	@objc func timerCallback() {
		timeoutNumber += 1
		if timeoutNumber >= 2 {
			nowIndex += 1
			if nowIndex > 5 {
				nowIndex = 0
			}
			print(nowIndex)
			let nextIndex = IndexPath(row: nowIndex, section: 0)
			self.centerCarouselCollectionView.scrollToItem(at: nextIndex, at: .right, animated: true)
		}
	}
}

extension CenterCarouselViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 6
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "centerCollectionViewCell", for: indexPath)
		cell.backgroundColor = UIColor.blue
		if indexPath.row != 0 {
			cell.transform =  CGAffineTransform(scaleX: 0.8, y: 0.8)
		}
		return cell
	}
	
	
	
	
}
extension CenterCarouselViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		resetTimer()
		setTimer()
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return minimumSpacing
	}
	
	
	
}

extension CenterCarouselViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return cellSize
	}
}
