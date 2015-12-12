Core
====

[![Swift 2.2](https://img.shields.io/badge/Swift-2.2-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms Linux | OSX](https://img.shields.io/badge/Platforms-Linux%20%7C%20OS%20X-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![License MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)](https://tldrlegal.com/license/mit-license)
[![Slack Status](https://zewo-slackin.herokuapp.com/badge.svg)](http://slack.zewo.io)

**Core** provides the base for Zewo frameworks.

## Types

- JSON
- MediaType
- POSIXRegex
- SSL
- Stream
- URI

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
$ brew udpate
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

[![Slack](http://s13.postimg.org/ybwy92ktf/Slack.png)](https://zewo-slackin.herokuapp.com)

Join us on [Slack](https://zewo-slackin.herokuapp.com).

License
-------

**Core** is released under the MIT license. See LICENSE for details.
