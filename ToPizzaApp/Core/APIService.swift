import UIKit
import Network

class APIService {
    static let shared = APIService()
    
    private let monitor = NWPathMonitor()
    private var isConnected = true
    
    private init() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        monitor.start(queue: DispatchQueue(label: "NetworkMonitor"))
    }
    
    func fetchCategories(completion: @escaping ([String]) -> Void, onNoInternet: (() -> Void)? = nil) {
        if isConnected {
            let url = URL(string: "https://fakestoreapi.com/products/categories")!
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    let categories = try? JSONDecoder().decode([String].self, from: data)
                    let result = categories ?? []
                    
                    CoreDataManager.shared.save(categories: result)
                    
                    DispatchQueue.main.async {
                        completion(result)
                    }
                } else {
                    let cached = CoreDataManager.shared.loadCategories()
                    DispatchQueue.main.async {
                        completion(cached)
                    }
                }
            }.resume()
        } else {
            onNoInternet?()
            let cached = CoreDataManager.shared.loadCategories()
            DispatchQueue.main.async {
                completion(cached)
            }
        }
    }
    
    func fetchProducts(for category: String, completion: @escaping ([Product]) -> Void, onNoInternet: (() -> Void)? = nil) {
        if isConnected {
            let urlString = "https://fakestoreapi.com/products/category/\(category)"
            guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
                completion([])
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    let products = try? JSONDecoder().decode([Product].self, from: data)
                    let result = products ?? []
                    
                    CoreDataManager.shared.save(products: result, for: category)
                    
                    DispatchQueue.main.async {
                        completion(result)
                    }
                } else {
                    let cached = CoreDataManager.shared.loadProducts(for: category)
                    DispatchQueue.main.async {
                        completion(cached)
                    }
                }
            }.resume()
        } else {
            
            DispatchQueue.main.async {
                onNoInternet?()
                let cached = CoreDataManager.shared.loadProducts(for: category)
                completion(cached)
            }
        }
    }
}
