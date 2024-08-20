//
//  MainTabBarController.swift
//  Demo
//
//  Created by elonfreedom on 2024/8/20.
//

import UIKit
import DesignKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        addChildViewControllers()
        preloadAllViewControllers()
    }

    func addChildViewControllers() {
        setChildViewController(NavChangeViewController(),
            title: "商城",
            imageName: "1.circle",
            selectedImageName: "1.circle")
        setChildViewController(NavChangeViewController(),
            title: "我的",
            imageName: "2.circle",
            selectedImageName: "2.circle")

    }

    func setChildViewController(_ childController: UIViewController,
        title: String,
        imageName: String,
        selectedImageName: String) {
//        let item = UITabBarItem.init(title:title,
//                                     image: UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal),
//                                     selectedImage:UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal))
//        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.DesignKit.primaryColor, NSAttributedString.Key.font: UIFont.jk.textM(11)], for: .selected)
//        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.DesignKit.subTextColor, NSAttributedString.Key.font: UIFont.jk.textM(11)], for: .normal)
//        item.selectedImage
        let item = UITabBarItem.init(title: title, image: UIImage(systemName: imageName), selectedImage: UIImage(systemName: imageName))
        childController.tabBarItem = item
        let navVc = NavigationController(rootViewController: childController)
        addChild(navVc)
    }

    func setTabBar() {
        view.backgroundColor = .white
//        let tabBar = UITabBar.appearance()
//        tabBar.barTintColor = .tabbarBackgroundColor
//        tabBar.backgroundColor(.tabbarBackgroundColor)
//        tabBar.tintColor(.themeColor)
//        tabBar.unselectedItemTintColor = UIColor.subTextColor
//        tabBar.isTranslucent = false
//        self.delegate = self
    }

    /// 强制加载所有子视图控制器的 view
    func preloadAllViewControllers() {
        guard let viewControllers = self.viewControllers else { return }

        for viewController in viewControllers {
            // 访问 viewController 的 view 属性，强制触发 viewDidLoad
            let _ = viewController.view
        }
    }


}
