import XCTest
@testable import ScreepsKit

final class ScreepsKitTests: XCTestCase {
    func testGeneratedReturnCodeAliasesMatchCanonicalValues() {
        XCTAssertEqual(ReturnCode.notEnoughResources.rawValue, ReturnCode.notEnoughEnergy.rawValue)
        XCTAssertEqual(ReturnCode.notEnoughResources.rawValue, ReturnCode.notEnoughExtensions.rawValue)
        XCTAssertEqual(ReturnCode.notInRange.rawValue, -9)
    }

    func testGeneratedEnumsPreserveScreepsRawValues() {
        XCTAssertEqual(ResourceType.energy.rawValue, "energy")
        XCTAssertEqual(StructureType.spawn.rawValue, "spawn")
        XCTAssertEqual(FindConstant.sources.rawValue, 105)
    }

    func testObjectIdRoundTripsRawValue() {
        let id = ObjectID<Creep>(rawValue: "abc123")
        XCTAssertEqual(id.rawValue, "abc123")
    }
}
