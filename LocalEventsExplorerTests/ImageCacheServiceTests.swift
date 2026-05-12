import XCTest
import UIKit
@testable import LocalEventsExplorer

final class ImageCacheServiceTests: XCTestCase {
    func testSetAndGetImage() {
        let size = CGSize(width: 10, height: 10)
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { ctx in
            UIColor.red.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
        }
        let url = URL(string: "https://example.com/test-image.png")!

        ImageCacheService.shared.removeImage(for: url)
        XCTAssertNil(ImageCacheService.shared.image(for: url))

        ImageCacheService.shared.setImage(img, for: url)
        let retrieved = ImageCacheService.shared.image(for: url)
        XCTAssertNotNil(retrieved)
        if let retrieved = retrieved as? UIImage {
            XCTAssertEqual(retrieved.size.width, img.size.width)
            XCTAssertEqual(retrieved.size.height, img.size.height)
        }
    }
}
