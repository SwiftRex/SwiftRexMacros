# SwiftRexMacros
Macros to help automating SwiftRex boilerplate

## Prism
A macro that produces predicates and prisms for all cases of an Enum.
Predicates will be Bool properties in the format `isCaseA` that returns `true` whenever that instance points to the `caseA` case of the enum.
Prism is a property with the same name as the case, but for the instance of the enum. If the instance points to that case, the variable will return a tuple of all associated values of that case, or instance of Void `()` for case without associated values. However, if the instance points to another case, it will return `nil`. This is extremely useful for using KeyPaths.

### Example of predicates:
```swift
@Prism
enum Color {
    case red, green, blue
}
```
produces:
```swift
extension Color {
    var isRed: Bool {
        if case .red = self { true } else { false }
    }
    var isGreen: Bool {
        if case .green = self { true } else { false }
    }
    var isBlue: Bool {
        if case .blue = self { true } else { false }
    }
}
```
usage:
```swift
let color1 = Color.red
color1.isRed // true
color1.isGreen // false
color1.isBlue // false
```

### Example os prism:
```swift
@Prism
enum Contact {
    case email(address: String)
    case phone(countryCode: String, number: String)
    case letter(street: String, house: String, postalCode: String, city: String, state: String, country: String)
    case noContact
}
```
produces:
```swift
extension Contact {
    var email: String? {
        guard case let .email(address) = self else { return nil }
        return address
    }
    var phone: (countryCode: String, number: String)? {
        guard case let .phone(countryCode, number) = self else { return nil }
        return (countryCode: countryCode, number: number)
    }
    var letter: (street: String, house: String, postalCode: String, city: String, state: String, country: String)? {
        guard case let .letter(street, house, postalCode, city, state, country) = self else { return nil }
        return (street: street, house: house, postalCode: postalCode, city: city, state: state, country: country)
    }
    var noContact: Void? {
        guard case .noContact = self else { return nil }
        return ()
    }
}
```

Please notice that the `Void` case is important not only for consistency, but for more advanced cases of composition.
Logically, a case with no associated values "holds" a Void associated value (singleton type), or not (nil) if the instance has another case.

usage:
```swift
let contact = Contact.phone(countryCode: "44", number: "078906789")
let phone = contact.phone.map { $0.countryCode + " " + $0.number } ?? "<No Phone>"     // "44 078906789"

let resolveEmail: KeyPath<Contact, String?> = \Contact.email    // passing contact will resolve to `nil`,
                                                                // but passing something with email will resolve to the addrees
```

Setter
Prisms also produce setters. In that case, if the enum case has an associated value and you want to change the values in the tuple, that is possible as long as the instance points to the same case, otherwise it will be ignored. For example:
```swift
var contact = Contact.phone(countryCode: "44", number: "078906789")
contact.phone = (countryCode: "44", number: "99999999")     // ✅ this change happens with success
contact.email = "my@email.com"                              // 🚫 this change is ignored, because the enum instance points to phone, not email
```

The setter can be really useful if you have a long tree of enums and want to change the leaf. It's also useful for `WritableKeyPath` situations.

Extra:
- Use `Prism` in the enum if you want to generate code for every case
- Use `PrismCase` in a case if you want a different visibility only for that case generated code.
- Use only `PrismCase` without `Prism` in the enum if you want code generated only for that case.
- Use `NoPrism` in a case if you don't want code generated for that case.

## PrismCase
A macro that produces predicates and prisms for a single case of an Enum.

### Example of predicates:
```swift
enum Color {
    case red, black
    @PrismCase
    case green, blue
    case yellow, white
}
```
produces:
```swift
extension Color {
    var isGreen: Bool {
        if case .green = self { true } else { false }
    }
    var isBlue: Bool {
        if case .blue = self { true } else { false }
    }
}
```
usage:
```swift
let color1 = Color.green
color1.isGreen // true
color1.isBlue // false
color1.isRed 🚫 // Compiler error, not generated
```

### Example os prism:
```swift
enum Contact {
    case email(address: String)
    @PrismCase
    case phone(countryCode: String, number: String)
    case letter(street: String, house: String, postalCode: String, city: String, state: String, country: String)
    case noContact
}
```
produces:
```swift
extension Contact {
    var phone: (countryCode: String, number: String)? {
        guard case let .phone(countryCode, number) = self else { return nil }
        return (countryCode: countryCode, number: number)
    }
}
```
Please notice that the `Void` case is important not only for consistency, but for more advanced cases of composition.
Logically, a case with no associated values "holds" a Void associated value (singleton type), or not (nil) if the instance has another case.

usage:
```swift
let contact = Contact.phone(countryCode: "44", number: "078906789")
let phone = contact.phone.map { $0.countryCode + " " + $0.number } ?? "<No Phone>"     // "44 078906789"

let resolveEmail: KeyPath<Contact, String?> = \Contact.phone?.number    // passing contact will resolve to `"078906789"`,
                                                                        // but passing something with email will resolve to nil
```

## NoPrism
A macro that prevents the code generatio of predicates and prisms for a specific case, in an Enum marked with `Prism`

### Example of predicates:
```swift
@Prism
enum Color {
    case red, green, blue
    @NoPrism
    case white, black
}
```
produces:
```swift
extension Color {
    var isRed: Bool {
        if case .red = self { true } else { false }
    }
    var isGreen: Bool {
        if case .green = self { true } else { false }
    }
    var isBlue: Bool {
        if case .blue = self { true } else { false }
    }
}
```
usage:
```swift
let color1 = Color.red
color1.isRed // true
color1.isGreen // false
color1.isBlue // false
color1.isWhite 🚫 // Compiler error, not generated
```

### Example os prism:
```swift
@Prism
enum Contact {
    case email(address: String)
    case phone(countryCode: String, number: String)
    @NoPrism
    case letter(street: String, house: String, postalCode: String, city: String, state: String, country: String)
    @NoPrism
    case noContact
}
```
produces:
```swift
extension Contact {
    var email: String? {
        guard case let .email(address) = self else { return nil }
        return address
    }
    var phone: (countryCode: String, number: String)? {
        guard case let .phone(countryCode, number) = self else { return nil }
        return (countryCode: countryCode, number: number)
    }
}
```
Please notice that the `Void` case is important not only for consistency, but for more advanced cases of composition.
Logically, a case with no associated values "holds" a Void associated value (singleton type), or not (nil) if the instance has another case.

usage:
```swift
let contact = Contact.phone(countryCode: "44", number: "078906789")
let phone = contact.phone.map { $0.countryCode + " " + $0.number } ?? "<No Phone>"     // "44 078906789"

let resolveEmail: KeyPath<Contact, String?> = \Contact.email    // passing contact will resolve to `nil`,
                                                                // but passing something with email will resolve to the addrees
```
