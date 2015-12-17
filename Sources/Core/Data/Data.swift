// Data.swift
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

public struct Data: ArrayLiteralConvertible, StringLiteralConvertible {

	private enum Storage {
		case Bytes([Int8])
		case Text(String)
	}

	private var raw: Storage

	// MARK: - Initializers

	public init(bytes: [Int8]) {
		self.raw = .Bytes(bytes)
	}

	public init(uBytes: [UInt8]) {
		self.raw = .Bytes(unsafeBitCast(uBytes, [Int8].self))
	}

	public init(string: String) {
		self.raw = .Text(string)
	}

	// MARK: - ArrayLiteralConvertible

	public init(arrayLiteral elements: UInt8...) {
		self.init(uBytes: elements)
	}

	// MARK: - StringLiteralConvertible

	public init(stringLiteral value: StringLiteralType) {
		self.init(string: value)
	}

	public init(extendedGraphemeClusterLiteral value: String) {
		self.init(string: value)
	}

	public init(unicodeScalarLiteral value: String) {
		self.init(string: value)
	}

	// MARK: - Length

	public var length: Int {
		switch raw {
		case .Bytes(let bytes):
			return bytes.count
		case .Text(let string):
			return string.nulTerminatedUTF8.count
		}
	}

	// MARK: - Getters

	public var bytes: [Int8] {
		switch raw {
		case .Bytes(let bytes):
			return bytes
		case .Text(let string):
			return unsafeBitCast(Array(string.nulTerminatedUTF8), [Int8].self)
		}
	}

	public var uBytes: [UInt8] {
		switch raw {
		case .Bytes(let bytes):
			return unsafeBitCast(bytes, [UInt8].self)
		case .Text(let string):
			return Array(string.nulTerminatedUTF8)
		}
	}

	public var string: String? {
		switch raw {
		case .Bytes(let bytes):
			return String.fromCString(bytes)
		case .Text(let string):
			return string
		}
	}

}
