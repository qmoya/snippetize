import XCTest
@testable import Snippetize

final class SnippetizeTests: XCTestCase {
	var sut: SnippetExtractor!

	override func setUp() async throws {
		try await super.setUp()
		sut = .live
	}
	
	func testUnindentedSnippet() throws {
		let string = """
		// snippet:start:hello_world.swift
		print("Hello, world!")
		// snippet:end:hello_world.swift
		"""
		
		let snippets = try sut.extract(string, "//")
		
		XCTAssertEqual(snippets, [
			.init(name: "hello_world.swift", contents: """
			print("Hello, world!")
			""")
		])
	}
	
	func testIndentedSnippet() throws {
		let string = """
		// snippet:start:hello_world.swift
			print("Hello, world!")
		// snippet:end:hello_world.swift
		"""
		
		let snippets = try sut.extract(string, "//")
		
		XCTAssertEqual(snippets, [
			.init(name: "hello_world.swift", contents: """
				print("Hello, world!")
			""")
		])
	}
	
	func testNestedSnippet() throws {
		let string = """
		// snippet:start:outer.swift
		for songwriter in ["Cole Porter", "Irving Berlin"] {
			// snippet:start:inner.swift
			print(songwriter)
			// snippet:end:inner.swift
		}
		// snippet:end:outer.swift
		"""
		
		let snippets = try sut.extract(string, "//")
		
		XCTAssertEqual(
			snippets,
			[
				.init(
					name: "outer.swift",
					contents: """
					for songwriter in ["Cole Porter", "Irving Berlin"] {
						print(songwriter)
					}
					"""
				),
				
				.init(
					name: "inner.swift",
					contents: """
					print(songwriter)
					"""
				)
			]
		)
	}
}
