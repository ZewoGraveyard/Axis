import PackageDescription

#if os(OSX)
    let package = Package(
        name: "Core",
        dependencies: [
            .Package(url: "https://github.com/Zewo/CURIParser.git", majorVersion: 0, minor: 1)
        ],
        exclude: ["Sources/UnitTests"]
    )
#else
    let package = Package(
        name: "Core",
        dependencies: [
            .Package(url: "https://github.com/Zewo/CURIParser.git", majorVersion: 0, minor: 1)
        ],
        targets: [
            Target(name: "UnitTests", dependencies: [.Target(name: "Core")]),
            Target(name: "Core")
        ]
    )
#endif