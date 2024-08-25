//
//  MainTabBarController.swift
//  Demo
//
//  Created by elonfreedom on 2024/8/20.
//

import UIKit
import OFBaseKit

class MainTabBarController: OFTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        addChildViewControllers()
        preloadAllViewControllers()
    }

    func addChildViewControllers() {
        setChildViewController(UIViewController(),
            title: "1",
            imageName: "1.circle",
            selectedImageName: "1.circle")
        
        setChildViewController(UIViewController(),
            title: "2",
            imageName: "2.circle",
            selectedImageName: "2.circle")
        
        setChildViewController(UIViewController(), title: "3", imageName: "3.circle", selectedImageName: "3.circle", navigationControllerType: UINavigationController.self)
        
        setChildViewController(UIViewController(), title: "4", imageName: "4.circle", selectedImageName: "4.circle", navigationControllerType: UINavigationController.self)
    }
}
