//
//  TabBarItems.swift
//  Diplom_Car
//
//  Created by Дмитрий Сазановец on 6/5/22.
//

import Foundation
import UIKit

class BarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContollers()
    
    }
    
    private func setupContollers () {
        
        tabBar.tintColor = UIColor.systemMint
        let infoVC = InfoBarVC(nibName: String(describing: InfoBarVC.self), bundle: nil)
        let serviceVC = ServiceBarVC(nibName: String(describing: ServiceBarVC.self), bundle: nil)
        let paperVC = PaperBarVC(nibName: String(describing: PaperBarVC.self), bundle: nil)
        
        infoVC.tabBarItem = UITabBarItem(title: "Информация", image: nil, tag: 0)
        serviceVC.tabBarItem = UITabBarItem(title: "Обслуживание", image: nil, tag: 1)
        paperVC.tabBarItem = UITabBarItem(title: "Документация", image: nil, tag: 2)
                
        self.viewControllers = [infoVC,serviceVC, paperVC]
    }
    

}
