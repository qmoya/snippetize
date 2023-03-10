//
//  File.swift
//  
//
//  Created by Quico Moya on 10.03.23.
//


public struct Snippet {
	public let name: String
	public let contents: String
}

public struct SnippetExtractor {
	public var extract: (_ source: String, _ commentMarker: String) throws -> [Snippet]
}

