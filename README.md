# Snippetize

A tool for extracting snippets of code from a real program, so that you can embed them
into a document.

## The problem

Imagine you’re writing, using LaTeX, or Pollen, or even Markdown, a book about programming. The book has fair amounts of code.

You could directly type the code into the text, but the code snippets could contain
typos, or not compile, or be inconsistent with other code snippets referenced elsewhere,
or not pass unit tests.

You don’t want any of that: you want the code you quote to be correct. It’s likely your readers will also want that.

## The solution

`snippetize` lets you turn actual programs into the source of your code snippets.

Whenever you want to quote a piece of code, go to the respective module 
—a Swift package, in the following example— and add a special comment, like this:

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

And have a look at the `Outputs` directory:

```sh
$ ls Outputs
greeter.swift
$ cat Outputs/greeter.swift
public init() {
	print(text)
}
```

Notice how `snippetize` removes the indentation from the snippet. It also strips any other overlapping snippet; none of the `snippet:`
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
