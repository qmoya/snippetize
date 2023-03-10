public struct Snippet: Equatable {
	public let name: String
	public let contents: String
}

public struct SnippetExtractor {
	public var extract: (_ source: String, _ commentMarker: String) throws -> [Snippet]
}
