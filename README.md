[Deprecated] Core
====

[![Swift 2.2](https://img.shields.io/badge/Swift-2.2-orange.svg?style=flat)](https://swift.org)
[![Platforms Linux](https://img.shields.io/badge/Platforms-Linux-lightgray.svg?style=flat)](https://swift.org)
[![License MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)](https://tldrlegal.com/license/mit-license)
[![Slack Status](http://slack.zewo.io/badge.svg)](http://slack.zewo.io)

**Core** provides the base for Zewo frameworks.

## Types

- Data
- File
- JSON
- MediaType
- POSIXRegex
- SSL
- Stream
- URI
- Base64
- EventEmitter

## Installation

- Install [`uri_parser`](https://github.com/Zewo/uri_parser)

### Linux

```bash
$ sudo add-apt-repository 'deb [trusted=yes] http://apt.zewo.io/deb ./'
$ sudo apt-get update
$ sudo apt-get install uri-parser
```

### OS X

```bash
$ brew tap zewo/tap
$ brew update
$ brew install uri_parser
```

- Add `Core` to your `Package.swift`

```swift
import PackageDescription

let package = Package(
	dependencies: [
		.Package(url: "https://github.com/Zewo/Core.git", majorVersion: 0, minor: 1)
	]
)
```

## Community

[![Slack](http://s13.postimg.org/ybwy92ktf/Slack.png)](http://slack.zewo.io)

Join us on [Slack](http://slack.zewo.io).

License
-------

**Core** is released under the MIT license. See LICENSE for details.
