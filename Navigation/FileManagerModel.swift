//
//  FileManagerModel.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 12/27/25.
//

import Foundation

final class FileManagerModel {

    // MARK: - Properties

    static let shared = FileManagerModel()

    var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    var itemsForSorting: [URL] = []

    var items: [URL] {
        get {
            let items = try! FileManager.default.contentsOfDirectory(
                at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0],
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            )

            return items
        }
    }

    // MARK: - Lifecycle

    private init() {}

    // MARK: - Public

    func addItem(url: URL) {
        let lastPathComponent = url.lastPathComponent

        let newURLOfCopiedItem = path.appendingPathComponent(lastPathComponent)

        do {
            try FileManager.default.copyItem(at: url, to: newURLOfCopiedItem)

            self.itemsForSorting.append(newURLOfCopiedItem)

            SettingViewController().sortingOnOff()
        } catch {
            print(error.localizedDescription)
        }
    }

    func removeItem(at index: Int) {
        let itemURL = itemsForSorting[index]

        itemsForSorting.remove(at: index)

        try? FileManager.default.removeItem(at: itemURL)
    }
}
