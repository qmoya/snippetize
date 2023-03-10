import ArgumentParser
import Foundation
import RegexBuilder

@main
struct Snippetizer: ParsableCommand {
	@Argument(help: "Path to scan for snippets.")
	var path: String
	
	@Option(name: .shortAndLong, help: "A marker indicating the start of a comment in the host language.")
	var commentMarker: String = "//"
	
	@Option(name: .shortAndLong, help: "The file extension to scan for snippets.")
	var `extension`: String = "swift"
	
	mutating func run() throws {
		let fileManager = FileManager.default
		
		// snippet:start:enumerator.swift
		let enumerator = fileManager.enumerator(atPath: path)
		
		while let file = enumerator?.nextObject() as? String {
			if file.hasSuffix(".swift") {
				let snippets = try extractSnippets(fromFileAt: path + "/" + file, commentMarker: commentMarker)
				for snippet in snippets {
					try snippet.contents.write(toFile: snippet.name, atomically: true, encoding: .utf8)
				}
				print(snippets)
			}
		}
		// snippet:end:enumerator.swift
	}
}

struct Snippet {
	let name: String
	let contents: String
}

func extractSnippet(fileContents: String, name: String, whitespace: String, commentMarker: String) -> Snippet? {
	let snippetReference = Reference<Substring>()
	let start: String = "\(whitespace)\(commentMarker) snippet:start:\(name)\n"
	let end: String = "\(whitespace)\(commentMarker) snippet:end:\(name)\n"

	let regex = Regex {
		start
		
		Capture(as: snippetReference) {
			ZeroOrMore {
				.any
			}
		}
		
		end
	}
	
	guard let match = fileContents.firstMatch(of: regex) else { return nil }
	let contents = String(match[snippetReference]).dropping(leadingWhitespace: whitespace)
	
	return .init(name: name, contents: contents)
	
}

extension String {
	func dropping(leadingWhitespace whitespace: String) -> String {
		let regex = Regex {
			Anchor.startOfLine
			
			whitespace
		}
		return replacing(regex, with: "")
	}
}

func extractSnippets(fromFileAt path: String, commentMarker: String) throws -> [Snippet] {
	let fileContents = try String(contentsOf: .init(filePath: path))
	let whitespaceReference = Reference<Substring>()
	let snippetNameReference = Reference<Substring>()
	
	let regex = Regex {
		.newlineSequence
		
		Capture(as: whitespaceReference) {
			ZeroOrMore {
				.horizontalWhitespace
			}
		}
		
		"// snippet:start:"
		
		Capture(as: snippetNameReference) {
			OneOrMore {
				.anyNonNewline
			}
		}
	}
	
	var snippets: [Snippet] = []
	
	let matches = fileContents.matches(of: regex)
	for match in matches {
		if let snippet = extractSnippet(
			fileContents: fileContents,
			name: String(match[snippetNameReference]),
			whitespace: String(match[whitespaceReference]),
			commentMarker: commentMarker
		) {
			snippets.append(snippet)
		}
	}
	
	return snippets
}
