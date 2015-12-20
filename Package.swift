import PackageDescription

let package = Package(
	name: "Core",
	dependencies: [
		.Package(url: "https://github.com/Zewo/CURIParser.git", majorVersion: 0, minor: 1)
	]
)
