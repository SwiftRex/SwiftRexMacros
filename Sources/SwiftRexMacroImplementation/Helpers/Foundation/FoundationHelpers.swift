import Foundation

extension Collection {
    public func mapIdentifyingLast<NewElement>(_ transform: (Element, Bool) -> NewElement) -> Array<NewElement> {
        let count = self.count
        return enumerated().map { i, item in
            transform(item, count - 1 == i )
        }
    }
}

extension String {
    public func uppercaseFirst() -> String {
        guard let first = self.first else { return "" }
        return "\(first.uppercased())\(dropFirst())"
    }
}
