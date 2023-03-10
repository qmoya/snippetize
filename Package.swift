// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Snippetize",
	platforms: [.macOS(.v13)],
	dependencies: [
		.package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.2"),
	],
	targets: [
		.executableTarget(
			name: "SnippetizeExec",
			dependencies: [
				"Snippetize",
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
			]
		),
		.target(name: "Snippetize"),
		.testTarget(
			name: "SnippetizeTests",
			dependencies: ["Snippetize"]
		),
	]
)
