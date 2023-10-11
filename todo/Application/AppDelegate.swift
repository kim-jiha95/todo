//
//  AppDelegate.swift
//  todo
//
//  Created by Jihaha kim on 2023/10/10.
//

import UIKit
import CoreData

/// **deploy target**
///
/// 보통 카카오톡 따라가는데
/// 15로 올리거든요? -2 +-1
/// 타겟 사용자층에 따라 달라져요
/// 젊은 사용자가 많다 == -1이 될 수도 있고
/// 개발자 파워가 쎄거나 IT기업이 근간이다 -1
/// 은행어플같은거
/// 대기업에서 만든거
/// 보수적이거나 돈에 쪼잔한 회사 -3 -4 17 13, 12
///
/// 사이드프로젝트 -0 ~ -1
/// 취준용 == 카카오톡 따라가면 됩니다.
///
/// 모든 세팅들을 취준에 다알기는 조금 힘들 수 있다.
/// 꼭 필요한 애들만 알면되고
/// 이런 애들은 조금 나중에 틈나는대로
///
/// **app setting**
/// scheme, target, framework, binary, compile, linking
/// 베이스 지식이 있는 상태에서 2~4일정도 보시면 될거라
///
/// **Foldering**
/// 앱 크기, 규모, 회사마다 취향
/// infoplist 위치 변경시
/// build setting -> todo/Resources/Info.plist
///
/// 하다가 완전막히거나 이해안되는 부분은 카톡으로 물어보시거나
/// 주석으로 질문 남겨주시면 좋을듯 합니다
///
/// 작업량이 적고 바로 볼만해서 안보고있는데,
/// 작업량이 많아지거나 하면 미리 PR같은거 올려주시면 좋을듯

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
