import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Schematic_CaptureTests.allTests),
    ]
}
#endif
