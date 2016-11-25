//
//  FLHomeViewController.swift
//  FamilyCook
//
//  Created by clarence on 16/11/25.
//  Copyright © 2016年 gitKong. All rights reserved.
//

import UIKit

class FLHomeViewController: UIViewController{
    
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
//        self.automaticallyAdjustsScrollViewInsets = false
        let carousel = FLCarouselView.init(frame: CGRect.init(x: 0, y: 64, width: view.fl_width, height: (view.fl_height - 64) * 0.4))
        carousel.dataSource = self
        carousel.delegate = self
        view.addSubview(carousel)
        
        let searchBar = UISearchBar.init(frame: CGRect.init(x: 10, y: (view.fl_height - 64) * 0.01 + carousel.fl_bottom, width: view.fl_width - 20, height: (view.fl_height - 64) * 0.08))
        searchBar.placeholder = "想吃什么搜啊"
        view.addSubview(searchBar)
        
        let tabView = UITableView.init(frame: CGRect.init(x: 0, y: searchBar.fl_bottom, width: view.fl_width, height: (view.fl_height - 64) * 0.5))
        tabView.backgroundColor = UIColor.gray
        tabView.delegate = self
        tabView.dataSource = self
        self.view.addSubview(tabView)
        
    }
    
    
}


extension FLHomeViewController :  UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell.init()
    }
}

extension FLHomeViewController :  FLCarouselViewDelegate, FLCarouselViewDataSource{
    func numberOfItems(carousel: FLCarouselView) -> Int{
        return 3
    }
    
    func carouselView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, reuseId : String) -> FLCarouselCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath as IndexPath) as! FLCarouselCell
        cell.backgroundColor = UIColor.init(red: CGFloat(Double(arc4random_uniform(256)) / 255.0), green: CGFloat(Double(arc4random_uniform(256)) / 255.0), blue: CGFloat(Double(arc4random_uniform(256)) / 255.0), alpha: 1.0)
        cell.imageView?.image = UIImage.init(named: "banner1")
        return cell
    }
}

