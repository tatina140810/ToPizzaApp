import UIKit
import SnapKit

final class TabBarController: UITabBarController {
    
    var shouldShowSuccessBanner = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        configureAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldShowSuccessBanner {
            shouldShowSuccessBanner = false
            showBanner(message: "Вход выполнен успешно", isSuccess: true)
        }
    }
    
    private func showBanner(message: String, isSuccess: Bool) {
        let banner = UIView()
        banner.backgroundColor = .white
        banner.layer.cornerRadius = 20
        banner.layer.shadowColor = UIColor.black.cgColor
        banner.layer.shadowOpacity = 0.1
        banner.layer.shadowOffset = CGSize(width: 0, height: 2)
        banner.layer.shadowRadius = 8
        banner.clipsToBounds = false
        
        let label = UILabel()
        label.text = message
        label.textAlignment = .center
        label.textColor = isSuccess ? .systemGreen : .systemRed
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        
        let icon = UIImageView()
        icon.image = isSuccess ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "xmark.circle.fill")
        icon.tintColor = label.textColor
        
        view.addSubview(banner)
        banner.addSubview(label)
        banner.addSubview(icon)
        
        banner.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.greaterThanOrEqualTo(50)
        }
        
        icon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(20)
        }
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(icon.snp.leading).offset(-8)
            $0.centerY.equalToSuperview()
        }
        
        banner.alpha = 0
        UIView.animate(withDuration: 0.3) {
            banner.alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            UIView.animate(withDuration: 0.3, animations: {
                banner.alpha = 0
            }) { _ in
                banner.removeFromSuperview()
            }
        }
    }
    
    private func setupTabs() {
        let menuVC = MenuViewController()
        let presenter = MenuPresenter(view: menuVC)
        menuVC.configure(with: presenter)
        
        let contactVC = ContactViewController()
        let profileVC = ProfileViewController()
        let cartVC = CartViewController()
        
        menuVC.tabBarItem = UITabBarItem(title: "Меню",
                                         image: UIImage(resource: .menu),
                                         selectedImage: UIImage(resource: .menu))
        contactVC.tabBarItem = UITabBarItem(title: "Контакты",
                                            image: UIImage(resource: .contact),
                                            selectedImage: UIImage(resource: .contact))
        profileVC.tabBarItem = UITabBarItem(title: "Профиль",
                                            image: UIImage(resource: .person),
                                            selectedImage: UIImage(resource: .person))
        cartVC.tabBarItem = UITabBarItem(title: "Корзина",
                                         image: UIImage(resource: .cart),
                                         selectedImage: UIImage(resource: .cart))
        
        viewControllers = [
            UINavigationController(rootViewController: menuVC),
            UINavigationController(rootViewController: contactVC),
            UINavigationController(rootViewController: profileVC),
            UINavigationController(rootViewController: cartVC)
        ]
    }
    
    private func configureAppearance() {
        tabBar.tintColor = UIColor(resource: .splash)
        tabBar.unselectedItemTintColor = UIColor(resource: .plholder)
        tabBar.backgroundColor = .white
    }
    
    @objc func locationTapped() {
        print("locationTapped")
    }
}
