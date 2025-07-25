import UIKit
import SnapKit

final class MessageBannerView: UIView {
    
    private let label = UILabel()
    private let iconView = UIImageView()
    private let contentStack = UIStackView()
    
    init(message: String, isSuccess: Bool) {
        super.init(frame: .zero)
        setupUI(message: message, isSuccess: isSuccess)
        animateInAndOut()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(message: String, isSuccess: Bool) {
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        
        iconView.image = isSuccess ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "xmark.circle.fill")
        iconView.tintColor = isSuccess ? .systemGreen : .systemPink
        iconView.contentMode = .scaleAspectFit
        iconView.setContentHuggingPriority(.required, for: .horizontal)
        
        label.text = message
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .center
        label.textColor = isSuccess ? .systemGreen : .systemPink
        label.numberOfLines = 1
        
        contentStack.axis = .horizontal
        contentStack.alignment = .center
        contentStack.spacing = 8
        contentStack.addArrangedSubview(label)
        contentStack.addArrangedSubview(iconView)
        
        addSubview(contentStack)
        contentStack.snp.makeConstraints { $0.edges.equalToSuperview().inset(16) }
    }
    
    private func animateInAndOut() {
        self.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }, completion: { _ in
                self.removeFromSuperview()
            })
        }
    }
}
