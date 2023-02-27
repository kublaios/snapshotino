//
//  SnapshotRetriever.swift
//  KleinSnapshotTestingTests
//
//  Created by Kubilay Erdogan on 2023-03-02.
//

import Foundation
import UIKit

struct SnapshotRetriever {
    enum SnapshotRetrieverError: Error {
        case imageRetrievalError, imageCreationError
    }

    let fileManager: FileManager = .default

    func retrieveSnapshot(of snapshottable: Snapshottable, file: String = #file) throws -> UIImage {
        let retrieveFromURL = try SnapshotFileURLBuilder()
            .build(
                nextTo: file,
                forType: type(of: snapshottable)
            )

        guard let imageData = fileManager.contents(atPath: retrieveFromURL.path) else {
            throw SnapshotRetrieverError.imageRetrievalError
        }

        guard let image = UIImage(data: imageData) else {
            throw SnapshotRetrieverError.imageCreationError
        }

        return image
    }
}
