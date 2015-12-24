// URITests.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Zewo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import XCTest
import Core

class URITests: XCTestCase {
    var allTests: [(String, Void -> Void)] {
        return [
            ("test", test)
        ]
    }

    func test() {
        let uri = URI(string: "abc://username:password@example.com:123/path/data?key=value#fragid1")
        XCTAssert(uri.scheme == "abc")
        XCTAssert(uri.userInfo?.username == "username")
        XCTAssert(uri.userInfo?.password == "password")
        XCTAssert(uri.host == "example.com")
        XCTAssert(uri.port == 123)
        XCTAssert(uri.path == "/path/data")
        XCTAssert(uri.query["key"] == "value")
        XCTAssert(uri.fragment == "fragid1")

        let uri2 = URI(path: "/api/v1/tasks", query: ["done": "true"])
        XCTAssert(uri2.path == "/api/v1/tasks")
        XCTAssert(uri2.query["done"] == "true")
    }
}
