//
//  SceneDelegate.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/04.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: scene.coordinateSpace.bounds)
        window?.windowScene = scene
        let loginViewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        loginViewController.loginCompletion = { [weak self] in
            self?.showTabBarController()
        }
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        showTabBarController()
    }
    
    // 로그인 성공 시 호출될 메서드
    func showTabBarController() {
        let tabBarController = UITabBarController()

        let homeViewController = HomeViewController()
        let myPageViewController = MyPageViewController()
        
        let vc1 = UINavigationController(rootViewController: homeViewController)
        let vc2 = UINavigationController(rootViewController: myPageViewController)
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc1.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        vc1.title = "HOME"
        vc2.tabBarItem.image = UIImage(systemName: "person")
        vc2.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        vc2.title = "MY PAGE"

        tabBarController.viewControllers = [vc1, vc2]
        tabBarController.tabBar.backgroundColor = .black
        tabBarController.tabBar.tintColor = .white
        tabBarController.tabBar.isTranslucent = false

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

