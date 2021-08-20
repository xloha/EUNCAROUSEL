//
//  BasicCarouselViewController.swift
//  EUNCAROUSEL
//
//  Created by 60080252 on 2020/11/05.
//

import UIKit

class BasicCarouselViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
	
	// Page Controller
	@IBOutlet weak var backgroundLinearView: UIView!
	@IBOutlet weak var foregroundLinearView: UIView!
	
	let cellSize = CGSize(width: 300, height: 200)
    let insetSize: CGFloat = 10
    let lineSpacing: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
	}
	
	override func viewDidLayoutSubviews() {
		setLinearPageController()
	}
    
    func configureCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.decelerationRate = .fast
    }
	
	// LinearPageController의 초기세팅
	func setLinearPageController() {
		let backgroundLinearViewWidth = backgroundLinearView.frame.size.width
		let foregroundLinearViewWidth = backgroundLinearViewWidth / CGFloat(ColorImg.colorList.count)
		foregroundLinearView.frame.size.width = foregroundLinearViewWidth
		
		NSLayoutConstraint.deactivate(foregroundLinearView.constraints)
		self.foregroundLinearView.translatesAutoresizingMaskIntoConstraints = false
		let constraints = [
			foregroundLinearView.heightAnchor.constraint(equalTo: backgroundLinearView.heightAnchor, multiplier: 1.0),
			foregroundLinearView.widthAnchor.constraint(equalToConstant: foregroundLinearViewWidth),
			foregroundLinearView.leadingAnchor.constraint(equalTo: backgroundLinearView.leadingAnchor),
			foregroundLinearView.topAnchor.constraint(equalTo: backgroundLinearView.topAnchor)
		]
		NSLayoutConstraint.activate(constraints)
	}
	
	// pageController의 currentPage
	var currentPage: Int = 0 {
		didSet {
			updateView()
		}
	}
	
	func updateView() {
		UIView.animate(withDuration: 0.3, animations: {
			let moveRight = CGAffineTransform(translationX: self.foregroundLinearView.bounds.width * CGFloat(self.currentPage), y: 0.0)
			self.foregroundLinearView.transform = moveRight
		})
	}
}

extension BasicCarouselViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ColorImg.colorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = UIImage(named: ColorImg.colorList[indexPath.row % ColorImg.colorList.count].img)
    
        cell.setBorderRound(cornerRadius: 10)
//        cell.setShadow(cornerRadius: 10, shadowRadius: 8, shadowOpacity: 0.1, shadowOffsetWidth: 2, shadowOffsetHeight: 0)
        return cell
    }
}

extension BasicCarouselViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWithSpacingWidth =  cellSize.width + lineSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWithSpacingWidth
        let roundedIndex: CGFloat = round(index)

        offset = CGPoint(x: roundedIndex * cellWithSpacingWidth - (scrollView.contentInset.left + lineSpacing + insetSize), y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
		
		// PageController 를 호출하면 됨
		currentPage = Int(roundedIndex)
    }
}
