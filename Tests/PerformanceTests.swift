import XCTest
import Foundation
@testable import Airport

let count = 10000 // 1, 10, 100, 1000, or 10000
let data = airportsJSON(count: count)

class PerformanceTests: XCTestCase {

    override class var defaultPerformanceMetrics: [XCTPerformanceMetric] {
        return [
            XCTPerformanceMetric(rawValue: "com.apple.XCTPerformanceMetric_WallClockTime"),
            XCTPerformanceMetric(rawValue: "com.apple.XCTPerformanceMetric_TransientHeapAllocationsKilobytes")
        ]
    }
    
    func testPerformanceCodable() {
        self.measure {
            let decoder = JSONDecoder()
            let airports = try! decoder.decode([Airport].self, from: data)
            XCTAssertEqual(airports.count, count)
        }
    }
    
    func testPerformanceJSONSerialization() {
        self.measure {
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
            let airports = json.map{ try! Airport(json: $0) }
            XCTAssertEqual(airports.count, count)
        }
    }
}
