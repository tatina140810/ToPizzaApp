import UIKit
import SnapKit

protocol LoginViewInput: AnyObject {
    func showBanner(message: String, isSuccess: Bool)
}

final class LoginViewController: UIViewController {
    var presenter: LoginViewOutput?
    
    private var logoTopConstraint: Constraint?
    private var bottomImageConstraint: Constraint?
    
    private let logoImage: UIImageView = {
        let image = UIImageView(image: UIImage(resource: .logoPink))
        return image
    }()
    
    private let loginTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Логин"
        tf.backgroundColor = .white
        tf.textColor = UIColor(resource: .text)
        tf.tintColor = UIColor(resource: .plholder)
        tf.layer.cornerRadius = 20
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(resource: .plholder).cgColor
        tf.clipsToBounds = true
        tf.font = UIFont.systemFont(ofSize: 14)
        
        let iconContainer = UIView()
        iconContainer.snp.makeConstraints { $0.width.equalTo(44); $0.height.equalTo(40) }
        
        let icon = UIImageView(image: UIImage(resource: .person).withRenderingMode(.alwaysTemplate))
        icon.tintColor = UIColor(resource: .plholder)
        icon.contentMode = .scaleAspectFit
        iconContainer.addSubview(icon)
        
        icon.snp.makeConstraints {
            $0.width.height.equalTo(18)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        tf.leftView = iconContainer
        tf.leftViewMode = .always
        
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Пароль"
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        tf.textColor = UIColor(resource: .text)
        tf.tintColor = UIColor(resource: .plholder)
        tf.layer.cornerRadius = 20
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(resource: .plholder).cgColor
        tf.clipsToBounds = true
        tf.font = UIFont.systemFont(ofSize: 14)
        
        
        let iconContainer = UIView()
        iconContainer.snp.makeConstraints { $0.width.equalTo(44); $0.height.equalTo(40) }
        
        let icon = UIImageView(image: UIImage(resource: .lock).withRenderingMode(.alwaysTemplate))
        icon.tintColor = UIColor(resource: .plholder)
        icon.contentMode = .scaleAspectFit
        iconContainer.addSubview(icon)
        
        icon.snp.makeConstraints {
            $0.width.height.equalTo(18)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        tf.leftView = iconContainer
        tf.leftViewMode = .always
        
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(resource: .eyeClose), for: .normal)
        eyeButton.tintColor = UIColor(resource: .plholder)
        eyeButton.frame = CGRect(x: 0, y: 0, width: 44, height: 40)
        
        eyeButton.addAction(UIAction { _ in
            tf.isSecureTextEntry.toggle()
            let iconName = tf.isSecureTextEntry ? UIImage(resource: .eyeClose) : UIImage(resource: .eyeOpen )
            eyeButton.setImage(iconName, for: .normal)
        }, for: .touchUpInside)
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 24))
        rightPaddingView.addSubview(eyeButton)
        eyeButton.center = rightPaddingView.center
        
        tf.rightView = rightPaddingView
        tf.rightViewMode = .always
        
        return tf
    }()
    
    private let bottomImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .white
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        image.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(resource: .splash)
        button.layer.cornerRadius = 20
        button.isEnabled = false
        button.alpha = 0.4
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        navigationItem.title = "Авторизация"
        setupUI()
        setupKeyboardObservers()
        setupTapGestureToDismissKeyboard()
        
        loginTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
    }
    
    private func setupUI() {
        [logoImage, loginTextField, passwordTextField, bottomImage].forEach { view.addSubview($0) }
        
        logoImage.snp.makeConstraints {
            logoTopConstraint = $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100).constraint
            $0.centerX.equalToSuperview()
            $0.height.equalTo(103)
            $0.width.equalTo(322)
        }
        
        loginTextField.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(343)
            $0.height.equalTo(48)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(loginTextField.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(343)
            $0.height.equalTo(48)
        }
        
        bottomImage.snp.makeConstraints {
            bottomImageConstraint = $0.bottom.equalTo(view.snp.bottom).constraint
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(118)
        }
        
        bottomImage.addSubview(loginButton)
        loginButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(343)
            $0.height.equalTo(48)
        }
    }
    
    @objc private func loginButtonTapped() {
        presenter?.didTapLogin(username: loginTextField.text, password: passwordTextField.text)
    }
    
    @objc private func textFieldsDidChange() {
        let isFormFilled = !(loginTextField.text?.isEmpty ?? true) && !(passwordTextField.text?.isEmpty ?? true)
        loginButton.isEnabled = isFormFilled
        loginButton.alpha = isFormFilled ? 1 : 0.4
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        logoTopConstraint?.update(offset: 16)
        bottomImageConstraint?.update(offset: -keyboardFrame.height + view.safeAreaInsets.bottom)
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        logoTopConstraint?.update(offset: 100)
        bottomImageConstraint?.update(offset: 0)
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension LoginViewController: LoginViewInput {
    func showBanner(message: String, isSuccess: Bool) {
        guard let navView = navigationController?.view else { return }
        
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
        
        navView.addSubview(banner)
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
}

