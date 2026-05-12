//
//  ImageCacheServiceTests.swift
//  LocalEventsExplorerTests
//
//  Created by Gurpreet Singh on 2026-05-12.
//

import XCTest
@testable import LocalEventsExplorer

final class ImageCacheServiceTests: XCTestCase {

    func testImageCanBeCachedAndLoaded() throws {

        let url = URL(string: "https://example.com/test-image.png")!

        let image = UIImage(systemName: "star")!
        let data = image.pngData()!

        ImageCacheService.shared.setImage(
            image,
            data: data,
            for: url
        )

        let cachedImage = ImageCacheService.shared.image(for: url)

        XCTAssertNotNil(cachedImage)
    }

    func testInvalidURLImageReturnsNil() {

        let url = URL(string: "https://example.com/not-cached-image.png")!

        let cachedImage = ImageCacheService.shared.image(for: url)

        XCTAssertNil(cachedImage)
    }

    func testMemoryCacheCanBeCleared() throws {

        let url = URL(string: "https://example.com/test-clear-image.png")!

        let image = UIImage(systemName: "heart")!
        let data = image.pngData()!

        ImageCacheService.shared.setImage(
            image,
            data: data,
            for: url
        )

        ImageCacheService.shared.clearMemoryCache()

        let cachedImage = ImageCacheService.shared.image(for: url)

        // Disk cache should still return image after memory cache is cleared.
        XCTAssertNotNil(cachedImage)
    }
}
