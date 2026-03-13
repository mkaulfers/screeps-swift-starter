import XCTest
import ScreepsKit

final class ScreepsSwiftStarterTests: XCTestCase {
    func testStarterConsumesPublishedScreepsKit() {
        XCTAssertEqual(ResourceType.energy.rawValue, "energy")
        XCTAssertEqual(ReturnCode.notInRange.rawValue, -9)
        XCTAssertEqual(FindConstant.sources.rawValue, 105)
    }
}
