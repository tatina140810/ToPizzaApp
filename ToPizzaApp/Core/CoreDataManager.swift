import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()

    private let persistentContainer: NSPersistentContainer

       var context: NSManagedObjectContext {
           persistentContainer.viewContext
       }

       private init() {
           persistentContainer = NSPersistentContainer(name: "ToPizzaApp")
           persistentContainer.loadPersistentStores { _, error in
               if let error = error {
                   fatalError("CoreData error: \(error.localizedDescription)")
               }
           }
       }
    
    func save(categories: [String]) {
        deleteAllCategories()
        
        for name in categories {
            let entity = CachedCategory(context: context)
            entity.name = name
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save categories:", error.localizedDescription)
        }
    }
    
    func loadCategories() -> [String] {
        let request: NSFetchRequest<CachedCategory> = CachedCategory.fetchRequest()
        do {
            let results = try context.fetch(request)
            return results.compactMap { $0.name }
        } catch {
            print("Failed to load categories:", error.localizedDescription)
            return []
        }
    }
    
    func deleteAllCategories() {
        let request: NSFetchRequest<CachedCategory> = CachedCategory.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
        deleteRequest.resultType = .resultTypeObjectIDs

        do {
            let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
            if let objectIDs = result?.result as? [NSManagedObjectID] {
                let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: objectIDs]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
            }
        } catch {
            print("Failed to delete categories:", error.localizedDescription)
        }
    }

    func save(products: [Product], for category: String) {
        for product in products {
            let entity = CachedProduct(context: context)
            entity.title = product.title
            entity.desc = product.description
            entity.image = product.image
            entity.price = product.price
            entity.category = category
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save products:", error.localizedDescription)
        }
    }
    
    func loadProducts(for category: String) -> [Product] {
        let request: NSFetchRequest<CachedProduct> = CachedProduct.fetchRequest()
        request.predicate = NSPredicate(format: "category == %@", category)
        
        do {
            let results = try context.fetch(request)
            return results.map {
                Product(title: $0.title ?? "",
                        description: $0.desc ?? "",
                        image: $0.image ?? "",
                        price: $0.price)
            }
        } catch {
            print("Failed to load products:", error.localizedDescription)
            return []
        }
    }
}
