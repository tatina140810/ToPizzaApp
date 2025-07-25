import UIKit
import SnapKit

class ButtonsCell: UICollectionViewCell {
    static let identifier = "ButtonsCell"
    
    private let button: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = UIColor(resource: .background)
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor(resource: .splash)
            .withAlphaComponent(0.2).cgColor
        button.layer.borderWidth = 1
        button.clipsToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with category: String, isSelected: Bool) {
        button.setTitle(category.capitalized, for: .normal)
        button.backgroundColor = isSelected
            ? UIColor(resource: .splash).withAlphaComponent(0.2)
            : UIColor(resource: .background)
        button.setTitleColor(
            isSelected
                ? UIColor(resource: .splash)
                : UIColor(resource: .splash).withAlphaComponent(0.2),
            for: .normal
        )
    }
}
