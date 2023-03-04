//
//  UIImage+Compare.swift
//  KleinSnapshotTestingTests
//
//  Created by Kubilay Erdogan on 2023-03-03.
//

import Foundation
import UIKit

extension UIImage {
    /// Compares the current image with another image pixel-by-pixel to determine if they are the same.
    ///
    /// - Parameters:
    ///   - referenceImage: The reference image to compare against.
    ///   - tolerance: The acceptable percentage of difference between the two images.
    ///     Default value is 0, max value is 1.0 (100%).
    /// - Returns: A boolean value indicating whether the two images are the same.
    ///
    /// - Note: This method expects the size of the two images to match.
    ///
    /// Sourced from https://github.com/facebookarchive/ios-snapshot-test-case/blob/master/FBSnapshotTestCase/Categories/UIImage%2BCompare.m
    func compare(with referenceImage: UIImage, tolerance: CGFloat = .zero) -> Bool {
        guard self.size == referenceImage.size else {
            assertionFailure("Images must be the same size.")
            return false
        }

        guard let cgImage, let referenceCGImage = referenceImage.cgImage else {
            assertionFailure("Could not get CGImage of image.")
            return false
        }

        let referenceImageSize = CGSize(width: cgImage.width, height: cgImage.height)
        let imageSize = CGSize(width: referenceCGImage.width, height: referenceCGImage.height)

        let minBytesPerRow = min(cgImage.bytesPerRow, referenceCGImage.bytesPerRow)
        let referenceImageSizeBytes = Int(referenceImageSize.height) * minBytesPerRow
        let referenceImagePixels = calloc(1, referenceImageSizeBytes)
        let imagePixels = calloc(1, referenceImageSizeBytes)

        guard let referenceImagePixels, let imagePixels else {
            free(referenceImagePixels)
            free(imagePixels)
            assertionFailure("Could not allocate memory for image pixels.")
            return false
        }

        let referenceImageContext = CGContext(
            data: referenceImagePixels,
            width: Int(referenceImageSize.width),
            height: Int(referenceImageSize.height),
            bitsPerComponent: cgImage.bitsPerComponent,
            bytesPerRow: minBytesPerRow,
            space: cgImage.colorSpace!,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )

        let imageContext = CGContext(
            data: imagePixels,
            width: Int(imageSize.width),
            height: Int(imageSize.height),
            bitsPerComponent: referenceCGImage.bitsPerComponent,
            bytesPerRow: minBytesPerRow,
            space: referenceCGImage.colorSpace!,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )

        guard let imageContext, let referenceImageContext else {
            free(referenceImagePixels)
            free(imagePixels)
            assertionFailure("Could not create CGContext for image and/or reference image.")
            return false
        }

        referenceImageContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: referenceImageSize.width, height: referenceImageSize.height))
        imageContext.draw(referenceCGImage, in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))

        var imagesAreEqual = true

        if tolerance == 0 {
            imagesAreEqual = memcmp(referenceImagePixels, imagePixels, referenceImageSizeBytes) == 0
        } else {
            let pixelCount = Int(referenceImageSize.width * referenceImageSize.height)

            let p1 = referenceImagePixels.assumingMemoryBound(to: UInt32.self)
            let p2 = imagePixels.assumingMemoryBound(to: UInt32.self)

            var numDiffPixels = 0

            for n in 0..<pixelCount {
                if p1[n] != p2[n] {
                    numDiffPixels += 1
                    let percent = CGFloat(numDiffPixels) / CGFloat(pixelCount)
                    if percent > tolerance {
                        imagesAreEqual = false
                        break
                    }
                }
            }

            print(CGFloat(numDiffPixels) / CGFloat(pixelCount))
        }

        free(referenceImagePixels)
        free(imagePixels)

        return imagesAreEqual
    }
}
