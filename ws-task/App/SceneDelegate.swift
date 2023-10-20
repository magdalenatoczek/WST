//
//  SceneDelegate.swift
//  ws-task
//
//  Created by Magdalena Toczek on 20/10/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var appCoordinator: BaseCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        appCoordinator = AppCoordinatorImpl(window: window, dependendies: WsDependencies())
        appCoordinator?.start()
    }
}
