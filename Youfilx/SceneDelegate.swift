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
        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        // 사용자 로그인 상태 확인
        if isLoggedIn() {
            // 로그인된 경우 탭 바 컨트롤러 표시
            showTabBarController()
        } else {
            // 로그인되어 있지 않은 경우 로그인 화면 표시
            showLoginViewController()
        }
    }
    
    // 사용자 로그인 상태를 확인하는 함수
    private func isLoggedIn() -> Bool {
        print(UserDefaults.standard.bool(forKey: "isLoggedIn"))
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    // 탭 바 컨트롤러를 표시하는 함수
    private func showTabBarController() {
        let tabBarController = UITabBarController()
        
        let homeViewController = HomeViewController()
        let myPageViewController = MyPageViewController()
        
        let vc1 = UINavigationController(rootViewController: homeViewController)
        let vc2 = UINavigationController(rootViewController: myPageViewController)
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc1.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        vc1.title = "홈"
        vc2.tabBarItem.image = UIImage(systemName: "person")
        vc2.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        vc2.title = "마이페이지"
        
        tabBarController.viewControllers = [vc1, vc2]
        tabBarController.tabBar.backgroundColor = .black
        tabBarController.tabBar.tintColor = .white
        tabBarController.tabBar.isTranslucent = false
        
        window?.rootViewController = tabBarController
    }
    
    // 로그인 뷰 컨트롤러를 표시하는 함수
    func showLoginViewController() {
        let loginViewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        loginViewController.loginCompletion = { [weak self] in
            // 로그인 성공 후 탭 바 컨트롤러 표시
            self?.showTabBarController()
        }
        window?.rootViewController = navigationController
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

