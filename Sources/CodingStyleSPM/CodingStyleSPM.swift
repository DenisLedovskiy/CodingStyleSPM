@propertyWrapper
public struct CodingStyle {

    public enum CodingCase {
        case camel, snake, kebab
    }

    private var value: String
    private let codingCase: CodingCase
    private static let codings: [CodingCase: (String) -> String] = [
        .camel: { value in
            let value = value.lowercased()
                .split(separator: " ")
                .drop { $0.isEmpty }
                .map { $0.prefix(1).uppercased()+$0.dropFirst() }
                .joined()
            return value.prefix(1).lowercased()+value.dropFirst()
        },
        .kebab: { value in
            value.lowercased()
                .split(separator: " ")
                .drop { $0.isEmpty }
                .joined(separator: "-")
        },
        .snake: { value in value.lowercased()
            .split(separator: " ")
            .drop { $0.isEmpty }
            .joined(separator: "_")
        }
    ]

    public init(wrappedValue: String, coding: CodingCase) {
        self.value = wrappedValue
        self.codingCase = coding
    }

    private func get() -> String {
        guard let coding = CodingStyle.codings[codingCase] else { return value }
        return coding(value)
    }

    private mutating func set(_ newValue: String) {
        value = newValue
    }

    public var wrappedValue: String {
        get {
            get()
        }
        set {
            set(newValue)
        }
    }
}

