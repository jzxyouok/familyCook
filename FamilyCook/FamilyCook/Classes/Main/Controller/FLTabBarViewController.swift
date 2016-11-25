//
//  FLTabBarViewController.swift
//  FamilyCook
//
//  Created by clarence on 16/11/25.
//  Copyright © 2016年 gitKong. All rights reserved.
//

import UIKit

class FLTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let homeVc = FLHomeViewController()
        self.addChildViewController(vc: homeVc, title: "家常菜谱大全", imageName: "", selectedImageName: "")
        
        let categoryVc = FLCategoryViewController()
        self.addChildViewController(vc: categoryVc, title: "分类", imageName: "", selectedImageName: "")
        
        let moreVc = FLMoreViewController()
        self.addChildViewController(vc: moreVc, title: "更多", imageName: "", selectedImageName: "")
    }

    func addChildViewController(vc : UIViewController , title : String , imageName : String , selectedImageName : String) {
        let nav = FLNavigationController.init(rootViewController: vc)
        vc.title = title
        let tabBarItem = UITabBarItem.init(title: title, image: UIImage.init(named: imageName), selectedImage: UIImage.init(named: selectedImageName))
        self.tabBarItem = tabBarItem
        self.addChildViewController(nav)
    }

}
