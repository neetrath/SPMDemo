//
//  StringExtensionTests.swift
//  sevenpeaks-ios-libTests
//
//  Created by Ruttanachai Auitragool on 23/9/22.
//

import XCTest
import sevenpeaks_ios_lib

final class StringExtensionTests: XCTestCase {
    func testTrim() throws {
        let oldText = " Hello   "
        let newText = oldText.trim()
        XCTAssertEqual(newText, "Hello")
    }
}
