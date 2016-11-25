//
//  FLNavigationController.swift
//  FamilyCook
//
//  Created by clarence on 16/11/25.
//  Copyright © 2016年 gitKong. All rights reserved.
//

import UIKit

class FLNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

}
