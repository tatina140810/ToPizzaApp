import UIKit
import SnapKit

class ProductCell: UICollectionViewCell {
    
    static let identifier = "ProductCell"
    
    let adImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(resource: .noimage)
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 6
        image.clipsToBounds = true
        return image
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(resource: .text)
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.textColor = UIColor(resource: .plholder)
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 6
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(resource: .splash)
        label.numberOfLines = 6
        label.layer.borderColor = UIColor(resource: .splash).cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        [adImageView, titleLabel, descriptionLabel, priceLabel].forEach {
            contentView.addSubview($0)
        }
        adImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(132)
            $0.height.equalTo(132)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalTo(adImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().offset(-12)
            $0.height.equalTo(30)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(48)
        }

        priceLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            $0.height.equalTo(32)
            $0.width.equalTo(87)
            $0.trailing.equalTo(titleLabel)
        }
    }
}
