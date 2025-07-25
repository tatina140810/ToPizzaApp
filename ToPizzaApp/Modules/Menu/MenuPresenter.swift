import UIKit

protocol MenuViewOutput: AnyObject {
    func viewDidLoad()
    func didSelectCategory(_ category: String)
}

final class MenuPresenter: MenuViewOutput {
    private weak var view: MenuViewInput?
    private let apiService: APIService
    
    private var categories: [String] = []
    private var products: [Product] = []
    
    init(view: MenuViewInput, apiService: APIService = .shared) {
        self.view = view
        self.apiService = apiService
    }
    
    func viewDidLoad() {
        apiService.fetchCategories(
            completion: { [weak self] categories in
                guard let self else { return }
                self.categories = categories
                let selected = categories.first ?? ""
                self.view?.display(categories: categories, selected: selected)
                self.didSelectCategory(selected)
            },
            onNoInternet: { [weak self] in
                (self?.view as? UIViewController)?.showNoInternetAlert()
            }
        )
    }
    
    func didSelectCategory(_ category: String) {
        apiService.fetchProducts(for: category) { [weak self] products in
            guard let self else { return }
            self.products = products
            self.view?.display(products: products)
        }
    }
}
