//
//  SceneDelegate.swift
//  Diplom_Car
//
//  Created by Дмитрий Сазановец on 6/4/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {return}
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        window?.rootViewController = UINavigationController(rootViewController: GarageVC(nibName: String(describing: GarageVC.self), bundle: nil))
        window?.makeKeyAndVisible()
    }
}
