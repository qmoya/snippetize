# Snippetize

A tool for extracting snippets of code from an actual program so you can embed them
into a document. The second-best thing after literate programming.

It’s written in Swift, but it’s not only for Swift.

## The problem

Imagine you’re writing a book about programming using LaTeX, Pollen, or even Markdown. The book has a fair amount of code.

You could directly type the code into the text, but the code snippets may contain
typos, or not compile, or be inconsistent with other code snippets referenced elsewhere, or fail unit tests.

You don’t want any of that: you want the code you quote to be correct. So do your readers.

## The solution

`snippetize` lets you turn actual programs into the source of your code snippets.

Whenever you want to quote a piece of code, go to the respective module 
—a Swift package, in the following example— and add a special comment:

```swift
public struct Greeter {
	public private(set) var text = "Hello, World!"

	// snippet:begin:greeter.swift
	public init() {
		print(text)
	}
	// snippet:end:greeter.swift
}
```

Then run `snippetize` on the package:

```
$ snipettize .
```

Now have a look at the `Outputs` directory:

```sh
$ ls Outputs
greeter.swift
$ cat Outputs/greeter.swift
public init() {
	print(text)
}
```

Notice how `snippetize` removes the indentation from the snippet. It also strips any other nested or overlapping snippet; none of the `snippet:`
comments will leak into your text.

You can now reference `greeter.swift` from your book’s source. In LaTeX, you’d
do something like

```latex
And here’s how you greet in Swift:

\include{Output/greeter.swift}
```

## Usage

```
USAGE: snippetize <path> [--comment-marker <comment-marker>] [--extension <extension>] [--output-dir <output-dir>]

ARGUMENTS:
  <path>                  Path to scan for snippets.

OPTIONS:
  -c, --comment-marker <comment-marker>
                          A marker indicating the start of a comment in the
                          host language. (default: //)
  -e, --extension <extension>
                          The file extension to scan for snippets. (default:
                          swift)
  -o, --output-dir <output-dir>
                          Where to output the snippets. (default: Output)
  -h, --help              Show help information.
```
