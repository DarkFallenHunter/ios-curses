//
//  TabBarController.swift
//  GameApp
//
//  Created by Юрий Воронцов on 01.04.2022.
//

import UIKit

class TabBarController: UITabBarController {

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isOpaque = true
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .white
        tabBar.backgroundColor = UIColor(red: 0.15, green: 0.29, blue: 0.86, alpha: 1.00)
        setupTabBar()
    }
}

private extension TabBarController {

    func setupTabBar() {
        let navCRPS = NavigationController(
            rootViewController: RPSViewController()
        )
        
        let navCDice = NavigationController(
            rootViewController: DiceViewController()
        )
        
        let imgConfig = UIImage.SymbolConfiguration(
            weight: .bold
        )

        navCRPS.tabBarItem = UITabBarItem(
            title: "RPS",
            image: UIImage(systemName: "scissors.circle"),
            selectedImage: UIImage(
                systemName: "scissors.circle.fill",
                withConfiguration: imgConfig
            )
        )
        
        navCDice.tabBarItem = UITabBarItem(
            title: "Dice",
            image: UIImage(systemName: "dice"),
            selectedImage: UIImage(
                systemName: "dice.fill", withConfiguration: imgConfig
            )
        )
        
        setViewControllers(
            [navCRPS, navCDice],
            animated: false
        )
    }
}
