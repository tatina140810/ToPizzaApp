import UIKit
import SnapKit

struct Product: Decodable {
    let title: String
    let description: String
    let image: String
    let price: Double
}

protocol MenuViewInput: AnyObject {
    func display(products: [Product])
    func display(categories: [String], selected: String)
}

final class MenuViewController: UIViewController {
    private let bannerImages: [UIImage] = [UIImage(resource: .baner1), UIImage(resource: .baner1)]
    private let categoryBar = CategoryBarView()
    private var presenter: MenuViewOutput!

    private var products: [Product] = []

    func configure(with presenter: MenuViewOutput) {
        self.presenter = presenter
    }

    private lazy var bannerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 280, height: 112)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        return collectionView
    }()

    private lazy var productCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 375, height: 156)
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.layer.cornerRadius = 20
        collectionView.clipsToBounds = true
        collectionView.dataSource = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(resource: .background)
        setupNavBar()
        [bannerCollectionView, categoryBar, productCollectionView].forEach {
            view.addSubview($0)
        }

        bannerCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(112)
        }

        categoryBar.snp.makeConstraints {
            $0.top.equalTo(bannerCollectionView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }

        productCollectionView.snp.makeConstraints {
            $0.top.equalTo(categoryBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupNavBar() {
        let button = UIButton(type: .system)
        button.setTitle("Москва", for: .normal)
        button.setImage(UIImage(resource: .icon), for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: -6)
        button.addTarget(self, action: #selector(cityTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }

    @objc private func cityTapped() {
        print("Город выбран")
    }

    private func loadImage(from urlString: String, into imageView: UIImageView) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
            }
        }
        .resume()
    }
}

extension MenuViewController: MenuViewInput {
    func display(products: [Product]) {
        self.products = products
        productCollectionView.reloadData()
    }

    func display(categories: [String], selected: String) {
        categoryBar.configure(categories: categories, selected: selected) { [weak self] category in
            self?.presenter.didSelectCategory(category)
        }
    }
}

extension MenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == bannerCollectionView ? bannerImages.count : products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier, for: indexPath) as! BannerCell
            cell.imageView.image = bannerImages[indexPath.item]
            return cell
        } else {
            let product = products[indexPath.item]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else {
                fatalError("Could not dequeue ProductCell")
            }

            cell.titleLabel.text = product.title
            cell.descriptionLabel.text = product.description
            cell.priceLabel.text = "от \(Int(product.price)) р"
            loadImage(from: product.image, into: cell.adImageView)
            return cell
        }
    }
}

extension UIViewController {
    func showNoInternetAlert() {
        let alert = UIAlertController(title: "Нет подключения",
                                      message: "Проверьте интернет-соединение и попробуйте снова.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        
        DispatchQueue.main.async {
            if self.view.window != nil {
                self.present(alert, animated: true)
            }
        }
    }
}

