import Foundation
import RegexBuilder

@available(macOS 13.0, *)
public extension SnippetExtractor {
	private static func extractSnippet(
		fileContents: String,
		name: String,
		whitespace: String,
		commentMarker: String
	) -> Snippet? {
		let snippetReference = Reference<Substring>()
		let start = "\(whitespace)\(commentMarker) snippet:start:\(name)"
		let end = "\(whitespace)\(commentMarker) snippet:end:\(name)"

		let regex = Regex {
			start
			
			One(.verticalWhitespace)

			Capture(as: snippetReference) {
				ZeroOrMore {
					.any
				}
			}

			One(.verticalWhitespace)

			end
		}

		guard let match = fileContents.firstMatch(of: regex) else { return nil }
		return .init(
			name: name,
			contents: String(match[snippetReference])
				.filteringSnippets()
				.dropping(leadingWhitespace: whitespace)
		)
	}
	
	static var live: Self = .init(extract: { fileContents, commentMarker in
		let whitespaceReference = Reference<Substring>()
		let snippetNameReference = Reference<Substring>()
		let startMarker = "\(commentMarker) snippet:start:"

		let regex = Regex {
			Capture(as: whitespaceReference) {
				ZeroOrMore {
					.horizontalWhitespace
				}
			}

			startMarker

			Capture(as: snippetNameReference) {
				OneOrMore {
					.anyNonNewline
				}
			}
		}

		return fileContents.matches(of: regex).compactMap { match in
			extractSnippet(
				fileContents: fileContents,
				name: String(match[snippetNameReference]),
				whitespace: String(match[whitespaceReference]),
				commentMarker: commentMarker
			)
		}
	})
}

extension String {
	@available(macOS 13.0, *)
	func dropping(leadingWhitespace whitespace: String) -> String {
		let regex = Regex {
			Anchor.startOfLine
			whitespace
		}
		return replacing(regex, with: "")
	}

	func filteringSnippets() -> String {
		var lines: [String] = []
		enumerateLines { line, _ in
			guard !line.contains("snippet:") else {
				return
			}
			lines.append(line)
		}
		return lines.joined(separator: "\n")
	}
}
