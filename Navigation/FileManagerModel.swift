//
//  FileManagerModel.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 12/27/25.
//

import Foundation

final class FileManagerModel {

    // MARK: - Properties

    var path: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    var items: [URL] {
        var items = try! FileManager.default.contentsOfDirectory(
            at: path,
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles
        )

        return items
    }

    // MARK: - Public

    func addItem(url: URL) {
        let lastPathComponent = url.lastPathComponent

        let newURLOfCopiedItem = path.appendingPathComponent(lastPathComponent)

        do {
            try FileManager.default.copyItem(at: url, to: newURLOfCopiedItem)
        } catch {
            print(error.localizedDescription)
        }
    }

    func removeItem(at index: Int) {
        let itemURL = items[index]
        
        try? FileManager.default.removeItem(at: itemURL)
    }
}
