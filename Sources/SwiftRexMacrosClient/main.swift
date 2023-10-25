import SwiftRexMacros
import Foundation

@Prism(visibility: .public)
enum Bla {
    case x, y, z
    case zzzz, xxxx
    @PrismCase(visibility: .private)
    case a(String)
    case b
    case c(Int, other: Date)
    case d(first: Int = 3, other: Date)
    case e(Int, Date)
    case someLongName
    @NoPrism
    case toBeIgnored
    @NoPrism
    case both, are, too, be, ignored

    var blablabla: String { "aaaa" }
    func blebleble() -> Int { 3 }
}

@Prism
enum Color0 {
    case red(brightness: Double)
}

@Prism
enum Color1 {
    case red
}

@Prism
enum Color2 {
    case red(Double)
}

@Prism
enum Color3 {
    case red(brightness: Double)
}

@Prism
enum Color4 {
    case red(Double, Double)
}

@Prism
enum Color5 {
    case red(brightness: Double, Double)
}

@Prism
enum Color6 {
    case red(brightness: Double, opacity: Double)
}

@Prism
enum Color7 {
    case red(Double, opacity: Double)
}
