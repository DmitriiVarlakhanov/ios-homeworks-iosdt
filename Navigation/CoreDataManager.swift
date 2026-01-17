//
//  CoreDataManager.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 1/10/26.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {

    // MARK: - Type properties

    static let shared = CoreDataManager()

    // MARK: - Properties

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")

        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var backgroundContext: NSManagedObjectContext = {
        let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

        backgroundContext.persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator

        return backgroundContext
    }()

    // MARK: - Lifecycle

    private init() {}

    // MARK: - Public

    func addToCoreData(
        authorLabel: String,
        imageData: Data,
        descriptionLabel: String,
        likesLabel: String,
        viewsLabel: String
    ) {
        /*
         self.backgroundContext.perform {
         let post = CoreDataPostModel(context: self.backgroundContext)

         post.authorLabel = authorLabel
         post.imageData = imageData
         post.descriptionLabel = descriptionLabel
         post.likesLabel = likesLabel
         post.viewsLabel = viewsLabel

         try? self.backgroundContext.save()
         }
         */

        self.persistentContainer.performBackgroundTask { backgroundContext in
            let post = CoreDataPostModel(context: backgroundContext)

            post.authorLabel = authorLabel
            post.imageData = imageData
            post.descriptionLabel = descriptionLabel
            post.likesLabel = likesLabel
            post.viewsLabel = viewsLabel

            let array = self.fetchFromCoreData()

            for object in array {
                if object.authorLabel == post.authorLabel && object.imageData == post.imageData && object.descriptionLabel == post.descriptionLabel && object.likesLabel == post.likesLabel && object.viewsLabel == post.viewsLabel {

                    DispatchQueue.main.async {
                        let controller = self.getTopMostViewController()

                        let alertController = UIAlertController(
                            title: "Alert",
                            message: "Already been added",
                            preferredStyle: .alert
                        )

                        let alertAction = UIAlertAction(
                            title: "Ok",
                            style: .cancel
                        )

                        alertController.addAction(alertAction)

                        controller?.present(alertController, animated: true)
                    }

                    return
                } else {
                    continue
                }
            }

            try? backgroundContext.save()
        }
    }

    func fetchFromCoreData() -> [CoreDataPostModel] {
        let request = CoreDataPostModel.fetchRequest()

        return (try? persistentContainer.viewContext.fetch(request)) ?? []
    }

    func deleteFromCoreData(post: CoreDataPostModel) {
        do {
            self.persistentContainer.viewContext.delete(post)

            try persistentContainer.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    func getTopMostViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first

        if let topController = keyWindow?.rootViewController {

            return topController.topMostViewController()
        }

        return nil
    }
}


/*
 Оптимизация:
 1) Использование "Allows External Storage" для картинок (тип Binary Data).

 2) Использование performBackgroundTask для того, чтобы дополнительно не создавать фоновые контексты в коде.
 */
