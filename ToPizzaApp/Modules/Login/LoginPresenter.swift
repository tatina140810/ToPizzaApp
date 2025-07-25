import UIKit

protocol LoginViewOutput {
    func didTapLogin(username: String?, password: String?)
}

final class LoginPresenter: LoginViewOutput {
    weak var view: LoginViewInput?
    
    init(view: LoginViewInput) {
        self.view = view
    }
    
    func didTapLogin(username: String?, password: String?) {
        guard username == "Admin", password == "1234" else {
            view?.showBanner(message: "Неверный логин или пароль", isSuccess: false)
            return
        }

        let tabBar = TabBarController()
        tabBar.shouldShowSuccessBanner = true
        
        let scene = UIApplication.shared.connectedScenes.first
        if let sceneDelegate = scene?.delegate as? SceneDelegate {
            UIView.transition(with: sceneDelegate.window!, duration: 0.5, options: .transitionCrossDissolve) {
                sceneDelegate.window?.rootViewController = tabBar
            }
        }
    }
}
