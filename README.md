# snapshottable

A lightweight, low-barrier-to-entry snapshot testing library for Swift

## Why snapshot tests?
- They're easy to write, maintain, and debug
- They focus on the visual output of your code (which is what the user sees)
- They encourage you to write small, modular, and testable components

## What this library is capable of
- Recording and comparing snapshots of `SwiftUI.View`, `UIView`, and `UIViewController`
- Storing the expected and actual snapshots in the test results

That's it!

### What it's definitely not capable of
- Recording snapshots using different accessibility traits or devices

### What it's probably not capable of
- Any other use cases that weren't mentioned above

## Author's note
If you are looking for a library that you will use on your production app, you should probably consider more powerful tools like [pointfreeco/swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing) or [uber/ios-snapshot-test-case](https://github.com/uber/ios-snapshot-test-case). This library is more of a pet project than a finished product. I wanted to snapshot-test the small apps and components I build for fun without importing a full-blown 3rd party for my limited use case.

## How to use
If you still want to use this library, here's how:
- Add the library as a dependency using Swift Package Manager
- Import `snapshottable` in your `XCTestCase` implementation
- Use `assertSnapshot` to record and compare snapshots, examples below

### For recording snapshots
Simply call `assertSnapshot` by setting `record` to `true`. The test will fail but the snapshot will be recorded under the `__snapshots__` folder next to the test file.

```swift
func testUIViewController() throws {
    try assertSnapshot(of: SampleViewController(), record: true)
}
```

### For asserting snapshots
Call `assertSnapshot` without setting the `record` attribute (it's `false` by default).

```swift
func testUIViewController() throws {
    try assertSnapshot(of: SampleViewController())
}

func testUIView() throws {
    if let view = Bundle.main.loadNibNamed("SampleView", owner: self, options: nil)?.first as? SampleView {
        try assertSnapshot(of: view)
    }
}

func testView() throws {
    let view = ContentView(viewModel: .init(imageName: "circle", text: "test"))
    try assertSnapshot(of: view.asSnapshottableView)
}
```

Note that `SwiftUI.View` cannot be used directly because it's not a concrete type. We use the `asSnapshottableView` property instead, which will return a wrapper type that can be passed to `assertSnapshot`.

## License
This project is released under the MIT license. See [LICENSE](LICENSE) for details.
