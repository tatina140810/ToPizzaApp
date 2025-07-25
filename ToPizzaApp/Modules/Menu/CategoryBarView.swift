import UIKit
import SnapKit

final class CategoryBarView: UIView {
    
    private var categories: [String] = []
    private var selectedCategory: String?
    private var onSelect: ((String) -> Void)?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 115, height: 32)
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ButtonsCell.self, forCellWithReuseIdentifier: ButtonsCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(categories: [String], selected: String?, onSelect: @escaping (String) -> Void) {
        self.categories = categories
        self.selectedCategory = selected
        self.onSelect = onSelect
        collectionView.reloadData()
    }
}

extension CategoryBarView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = categories[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonsCell.identifier, for: indexPath) as! ButtonsCell
        cell.configure(with: category, isSelected: category == selectedCategory)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.item]
        selectedCategory = category
        collectionView.reloadData()
        onSelect?(category)
    }
}
