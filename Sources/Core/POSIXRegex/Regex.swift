// Regex.swift
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

import Gamut

struct RegexError : ErrorType {
    let description: String

    static func errorFromResult(result: Int32, var preg: regex_t) -> RegexError {
        var buffer = [Int8](count: Int(BUFSIZ), repeatedValue: 0)
        regerror(result, &preg, &buffer, buffer.count)
        let description = String.fromCString(buffer)!
        return RegexError(description: description)
    }
}

public final class Regex {
    public struct RegexOptions: OptionSetType {
        public let rawValue: Int32

        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }

        public static let Basic =            RegexOptions(rawValue: REG_BASIC)
        public static let Extended =         RegexOptions(rawValue: REG_EXTENDED)
        public static let CaseInsensitive =  RegexOptions(rawValue: REG_ICASE)
        public static let ResultOnly =       RegexOptions(rawValue: REG_NOSUB)
        public static let NewLineSensitive = RegexOptions(rawValue: REG_NEWLINE)
    }

    public struct MatchOptions: OptionSetType {
        public let rawValue: Int32

        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }

        public static let FirstCharacterNotAtBeginningOfLine = MatchOptions(rawValue: REG_NOTBOL)
        public static let LastCharacterNotAtEndOfLine =        MatchOptions(rawValue: REG_NOTEOL)
    }

    var preg = regex_t()

    public init(pattern: String, options: RegexOptions = [.Extended]) throws {
        let result = regcomp(&preg, pattern, options.rawValue)

        if result != 0 {
            throw RegexError.errorFromResult(result, preg: preg)
        }
    }

    deinit {
        regfree(&preg)
    }

    public func matches(string: String, options: MatchOptions = []) -> Bool {
        var regexMatches = [regmatch_t](count: 1, repeatedValue: regmatch_t())
        let result = regexec(&preg, string, regexMatches.count, &regexMatches, options.rawValue)

        if result == REG_NOMATCH {
            return false
        }

        return true
    }

    public func groups(var string: String, options: MatchOptions = []) -> [String] {
        let maxMatches = 10
        var groups = [String]()

        while true {
            var regexMatches = [regmatch_t](count: maxMatches, repeatedValue: regmatch_t())
            let result = regexec(&preg, string, regexMatches.count, &regexMatches, options.rawValue)

            if result == REG_NOMATCH {
                break
            }

            for var j = 1; regexMatches[j].rm_so != -1; j++ {
                let start = Int(regexMatches[j].rm_so)
                let end = Int(regexMatches[j].rm_eo)
                if let match = String(string.utf8[string.utf8.startIndex.advancedBy(start) ..< string.utf8.startIndex.advancedBy(end)]) {
                    groups.append(match)
                }
            }

            let offset = Int(regexMatches[0].rm_eo)
            if let offsetString = String(string.utf8[string.utf8.startIndex.advancedBy(offset) ..< string.utf8.endIndex]) {
                string = offsetString
            } else {
                break
            }
        }

        return groups
    }

    public func replace(var string: String, withTemplate template: String, options: MatchOptions = []) -> String {
        let maxMatches = 10
        var totalReplacedString: String = ""

        while true {
            var regexMatches = [regmatch_t](count: maxMatches, repeatedValue: regmatch_t())
            let result = regexec(&preg, string, regexMatches.count, &regexMatches, options.rawValue)

            if result == REG_NOMATCH {
                break
            }

            let start = Int(regexMatches[0].rm_so)
            let end = Int(regexMatches[0].rm_eo)

            var replacedStringArray = Array<UInt8>(string.utf8)
            let templateArray = Array<UInt8>(template.utf8)
            replacedStringArray.replaceRange(start ..<  end, with: templateArray)

            guard var replacedString = String(data: replacedStringArray) else {
                break
            }

            let templateDelta = template.utf8.count - (end - start)
            let templateDeltaIndex = replacedString.utf8.startIndex.advancedBy(Int(end + templateDelta))

            replacedString = String(replacedString.utf8[replacedString.utf8.startIndex ..< templateDeltaIndex])

            totalReplacedString += replacedString
            string = String(string.utf8[string.utf8.startIndex.advancedBy(end) ..< string.utf8.endIndex])
        }
        
        return totalReplacedString + string
    }
}

extension String {
    public init?(data: [UInt8]) {
        var string = ""
        var decoder = UTF8()
        var generator = data.generate()
        var finished = false

        while !finished {
            let decodingResult = decoder.decode(&generator)
            switch decodingResult {
            case .Result(let char): string.append(char)
            case .EmptyInput: finished = true
            case .Error: return nil
            }
        }

        self.init(string)
    }
}