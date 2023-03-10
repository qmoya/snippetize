import ArgumentParser
import Foundation
import RegexBuilder
import Snippetize

@main
struct Snippetize: ParsableCommand {
	@Argument(help: "Path to scan for snippets.")
	var path: String

	@Option(
		name: .shortAndLong,
		help: "A marker indicating the start of a comment in the host language."
	)
	var commentMarker: String = "//"

	@Option(name: .shortAndLong, help: "The file extension to scan for snippets.")
	var `extension`: String = "swift"

	@Option(name: .shortAndLong, help: "Where to output the snippets.")
	var outputDir: String = "Output"

	@available(macOS 13.0, *)
	mutating func run() throws {
		let fileManager = FileManager.default

		try fileManager.createDirectory(at: .init(filePath: outputDir), withIntermediateDirectories: true)

		// snippet:start:enumerator.swift
		let enumerator = fileManager.enumerator(atPath: path)

		let extractor: SnippetExtractor = .live

		// snippet:start:something_else.swift
		while let file = enumerator?.nextObject() as? String {
			if file.hasSuffix(".swift") {
				let fileContents = try String(contentsOfFile: path + "/" + file)
				let snippets = try extractor.extract(fileContents, commentMarker)
				for snippet in snippets {
					try snippet.contents.write(
						toFile: outputDir + "/" + snippet.name,
						atomically: true,
						encoding: .utf8
					)
				}
			}
		}
		// snippet:end:enumerator.swift
		// snippet:end:something_else.swift
	}
}
