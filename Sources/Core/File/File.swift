// File.swift
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

#if os(Linux)
	import Glibc
#else
	import Darwin.C
#endif

public class File {
	
	public enum Error: ErrorType {
		case OpenError(String)
		case WriteError
	}
	
	public static func write(path: String, data: Data, append: Bool = false) throws {
		let mode = append ? "a" : "w"
		let fp = fopen(path, mode)
		guard fp != nil else { throw Error.OpenError(String.fromCString(strerror(errno)) ?? "") }
		defer { fclose(fp) }
		let count = fwrite(data.uBytes, 1, data.length, fp)
		guard count == data.length else { throw Error.WriteError }
	}
	
	public static func read(path: String) throws -> Data {
		let fp = fopen(path, "r")
		guard fp != nil else { throw Error.OpenError(String.fromCString(strerror(errno)) ?? "") }
		defer { fclose(fp) }
		var bytes: [UInt8] = []
		let buffer = UnsafeMutablePointer<UInt8>.alloc(1024)
		defer { buffer.dealloc(1024) }
		repeat {
			let count = fread(buffer, 1, 1024, fp)
			if ferror(fp) != 0 { break }
			guard count > 0 else { continue }
			bytes += Array(UnsafeBufferPointer(start: buffer, count: count).generate()).prefix(count)
		} while feof(fp) == 0
		return Data(uBytes: bytes)
	}
	
}
