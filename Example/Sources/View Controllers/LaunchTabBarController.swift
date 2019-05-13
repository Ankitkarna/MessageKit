//
//  LaunchTabBarController.swift
//  ChatExample
//
//  Created by Ankit Karna on 5/13/19.
//  Copyright © 2019 MessageKit. All rights reserved.
//

import UIKit

class LaunchTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addTabBars()
    }

    private func addTabBars() {
        var controllers = [UIViewController]()
        let launchController = NavigationController(rootViewController: LaunchViewController())
        controllers.append(launchController)

        let settingsController = SettingsViewController()
        controllers.append(settingsController)

        viewControllers = controllers
    }

}
