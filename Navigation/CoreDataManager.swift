//
//  CoreDataManager.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 1/10/26.
//

import Foundation
import CoreData

class CoreDataManager {

    // MARK: - Type properties

    static let shared = CoreDataManager()

    // MARK: - Properties

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")

        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
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
        let post = CoreDataPostModel(context: persistentContainer.viewContext)

        post.authorLabel = authorLabel
        post.imageData = imageData
        post.descriptionLabel = descriptionLabel
        post.likesLabel = likesLabel
        post.viewsLabel = viewsLabel

        try? persistentContainer.viewContext.save()
    }

    func fetchFromCoreData() -> [CoreDataPostModel] {
        let request = CoreDataPostModel.fetchRequest()

        return (try? persistentContainer.viewContext.fetch(request)) ?? []
    }
}
