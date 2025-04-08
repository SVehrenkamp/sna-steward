func group<T: Groupable>(_ items: [T]) -> [String: [T]] {
    return Dictionary(grouping: items) { item in
        item.group
    }
}

// Protocol to ensure items have a group property
public protocol Groupable {
    var group: String { get }
}
