//
//  FLCarousel.swift
//  Swift_Demo
//
//  Created by clarence on 16/8/30.
//  Copyright © 2016年 clarence. All rights reserved.
//

import UIKit

class FLCarouselCell: UICollectionViewCell {
    var imageView : UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        self.addSubview(imageView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private let reuseId : String = "FLCarouselReuseId"

class FLCarouselView: UIView {
    
    // 轮播时间间隔
    var fl_scrollTimeInterval : Double = 0.0{
        didSet{
            invalidateTimer()
            // 创建定时器
            timer = Timer.scheduledTimer(timeInterval: fl_scrollTimeInterval, target: self, selector: #selector(FLCarouselView.autoScroll), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
        }
    }
    
    weak var delegate : FLCarouselViewDelegate?
    weak var dataSource : FLCarouselViewDataSource?
    
    
    public var numberOfItems : Int? {
        willSet {
            realItems = newValue! * 1000
            pageControl?.numberOfPages = newValue!
        }
        didSet {
            
        }
    }
    
    public var collectionView : UICollectionView?
    let flowLayout = UICollectionViewFlowLayout()
    
    var realItems : Int = 0
    
    public var timer : Timer?
    
    public var pageControl : UIPageControl?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 创建控件
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: self.frame.size.width,height:self.frame.size.height)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height), collectionViewLayout: flowLayout)
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView!.register(FLCarouselCell.self, forCellWithReuseIdentifier: reuseId)
        self.addSubview(collectionView!)
        
        pageControl = UIPageControl.init(frame: CGRect.init(x: (frame.size.width - 100) / 2, y: frame.size.height - 20, width: 100, height: 20))
        pageControl?.currentPageIndicatorTintColor = UIColor.red
        pageControl?.pageIndicatorTintColor = UIColor.white
        
        self.addSubview(pageControl!)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 刷新轮播
    func fl_reloadData() -> () {
        numberOfItems = (dataSource?.numberOfItems(carousel: self))!
        
        collectionView?.reloadData()
        if collectionView?.contentOffset.x == 0 && realItems != 0 {
            collectionView?.scrollToItem(at: NSIndexPath.init(item: realItems / 2, section: 0) as IndexPath, at: UICollectionViewScrollPosition.top, animated: false)
        }
    }
    
    func autoScroll() -> () {
        if 0 == realItems {
            return
        }
//        print(collectionView?.contentOffset.x)
        // 设置滚动
        let currentIndex = Int((collectionView?.contentOffset.x)! / flowLayout.itemSize.width)
        var startIndex = currentIndex + 1
        if startIndex == realItems {
            startIndex = realItems / 2
            collectionView?.scrollToItem(at: NSIndexPath.init(item:startIndex , section: 0) as IndexPath, at: UICollectionViewScrollPosition.top, animated: false)
        }
        collectionView?.scrollToItem(at: NSIndexPath.init(item:startIndex , section: 0) as IndexPath, at: UICollectionViewScrollPosition.top, animated: true)
    }
    
    deinit{
        invalidateTimer()
    }
    
    func invalidateTimer() -> () {
        timer?.invalidate()
        timer = nil
    }
}

extension FLCarouselView{
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if numberOfItems == 0 {
            return
        }
        pageControl?.currentPage = Int(((collectionView?.contentOffset.x)! + flowLayout.itemSize.width / 2) / flowLayout.itemSize.width) % numberOfItems!
        // 这个方法执行了18次。。。为啥
//        print("--")
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        invalidateTimer()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        invalidateTimer()
        // 创建定时器
        timer = Timer.scheduledTimer(timeInterval: fl_scrollTimeInterval, target: self, selector: #selector(FLCarouselView.autoScroll), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
}

extension FLCarouselView : UICollectionViewDelegate,UICollectionViewDataSource {
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return (dataSource?.carouselView(collectionView: collectionView, cellForItemAtIndexPath: indexPath as NSIndexPath, reuseId: reuseId))!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.carouselView!(collectionView: collectionView, didSelectItemAtIndexPath: indexPath.item % numberOfItems!)
    }
}

protocol FLCarouselViewDataSource : NSObjectProtocol {
    func numberOfItems(carousel: FLCarouselView) -> Int

    func carouselView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, reuseId : String) -> FLCarouselCell
}

//添加@objc修饰符并不意味着这个方法或者属性会变成动态派发，Swift依然可能会将其优化为静态调用。如果你需要和Objective-C里动态调用时相同的运行时特性的话，你需要使用的修饰符是dynamic
@objc
protocol FLCarouselViewDelegate {
    // 创建很多items，因此要拿到具体的值不能传indexPath,有numberOfItems * 1000 个，达到无限循环
    @objc optional func carouselView(collectionView: UICollectionView,didSelectItemAtIndexPath index : NSInteger) -> ()
}

