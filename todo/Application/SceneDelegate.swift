//
//  SceneDelegate.swift
//  todo
//
//  Created by Jihaha kim on 2023/10/10.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        // 윈도우를 설정해주고,
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        // 네비게이션 컨트롤러의 초기 루트 뷰 컨트롤러를 생성
        let rootViewController: TodoViewController = TodoViewController() // 이 부분에 초기 뷰 컨트롤러를 지정
        
        // 네비게이션 컨트롤러를 생성하고 루트 뷰 컨트롤러로 설정
        let navigationController: UINavigationController = UINavigationController(rootViewController: rootViewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

}

