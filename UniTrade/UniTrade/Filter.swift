struct Filter {
    var minPrice: Double?
    var maxPrice: Double?
    var sortOption: String?
    var isAscending: Bool = true

    var isActive: Bool {
        return minPrice != nil || maxPrice != nil || sortOption != nil
    }
}
