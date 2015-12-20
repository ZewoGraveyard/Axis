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
		case ReadError(String)
		case WriteError(String)
	}
	
	public enum Mode: String {
		case Read = "r"				// Open file for reading
		case Write = "w"			// Truncate to zero length or create file for writing
		case Append = "a"			// Append; open or create file for writing at end-of-file
		case ReadUpdate = "r+"		// Open file for update (reading and writing)
		case WriteUpdate = "w+"		// Truncate to zero length or create file for update
		case AppendUpdate = "a+"	// Append; open or create file for update, writing at end-of-file
	}
	
	private let fp: UnsafeMutablePointer<FILE>
	
	public init(path: String, mode: Mode = .ReadUpdate) throws {
		fp = fopen(path, mode.rawValue)
		guard fp != nil else { throw Error.OpenError(String.fromCString(strerror(errno)) ?? "") }
	}
	
	deinit {
		close()
	}
	
	public func write(data: Data) throws {
		let count = fwrite(data.uBytes, 1, data.length, fp)
		guard count == data.length else { throw Error.WriteError(String.fromCString(strerror(ferror(fp))) ?? "") }
	}
	
	public func read(length length: Int = Int.max) throws -> Data {
		var bytes: [UInt8] = []
		var remaining = length
		let buffer = UnsafeMutablePointer<UInt8>.alloc(1024)
		defer { buffer.dealloc(1024) }
		repeat {
			let count = fread(buffer, 1, min(remaining, 1024), fp)
			guard ferror(fp) == 0 else { throw Error.ReadError(String.fromCString(strerror(ferror(fp))) ?? "") }
			guard count > 0 else { continue }
			bytes += Array(UnsafeBufferPointer(start: buffer, count: count).generate()).prefix(count)
			remaining -= count
		} while remaining > 0 && feof(fp) == 0
		return Data(uBytes: bytes)
	}
	
	public func close() {
		if fp != nil {
			fclose(fp)
		}
	}
	
}
