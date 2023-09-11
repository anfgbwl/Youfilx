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
            self.showTabBarController()
        } else {
            // 로그인되어 있지 않은 경우 로그인 화면 표시
            self.showLoginViewController()
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
    
}

