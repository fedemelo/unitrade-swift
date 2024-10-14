import SwiftUI

struct FilterView: View {
    @Binding var isPresented: Bool
    @Binding var filter: Filter

    @State private var selectedSortOption: String? = nil
    @State private var isAscending: Bool = true
    @State private var minPrice: String = ""
    @State private var maxPrice: String = ""
    @State private var hasInteractedWithPrice = false

    let sortOptions = ["Rating", "Price"]

    // Logic to determine if the Apply button is enabled
    private var isApplyButtonEnabled: Bool {
        let minValue = Double(minPrice)
        let maxValue = Double(maxPrice)

        let arePricesValid = minValue != nil && maxValue != nil && minValue! <= maxValue!
        let arePricesPartiallyFilled = (minPrice.isEmpty != maxPrice.isEmpty)

        return (arePricesValid && !minPrice.isEmpty && !maxPrice.isEmpty) ||
               (selectedSortOption != nil && !arePricesPartiallyFilled &&
                (arePricesValid || (minPrice.isEmpty && maxPrice.isEmpty)))
    }

    // Error message logic
    private var errorMessage: String? {
        guard hasInteractedWithPrice else { return nil }
        if minPrice.isEmpty || maxPrice.isEmpty {
            return "Please enter both minimum and maximum prices."
        }
        if let min = Double(minPrice), let max = Double(maxPrice), min > max {
            return "The minimum price cannot be greater than the maximum price."
        }
        return nil
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading) {
                // Price Range Inputs
                PriceRangeView(minPrice: $minPrice, maxPrice: $maxPrice)
                    .padding(.bottom, 5)
                    .onChange(of: minPrice) { hasInteractedWithPrice = true }
                    .onChange(of: maxPrice) { hasInteractedWithPrice = true }

                if let message = errorMessage {
                    Text(message)
                        .font(Font.DesignSystem.bodyText100)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                        .padding(.bottom, 15)
                }

                // Sort Options
                Text("Sort By")
                    .font(Font.DesignSystem.headline600)
                    .foregroundStyle(Color.DesignSystem.secondary900())
                    .padding(.bottom, 10)
                    .padding(.leading)

                Picker("Select Sort Option", selection: $selectedSortOption) {
                    ForEach(sortOptions, id: \.self) { option in
                        Text(option).tag(option as String?)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .foregroundStyle(Color.DesignSystem.primary900())

                // Sort Order Toggle
                HStack {
                    Text("Order:")
                        .font(Font.DesignSystem.bodyText300)
                        .foregroundStyle(Color.DesignSystem.primary600())
                        .padding(.leading)
                    Spacer()

                    Picker("Order", selection: $isAscending) {
                        Text("Ascendant").tag(true)
                        Text("Descendant").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.trailing)
                }
                .padding(.vertical, 20)
                .padding(.bottom, 50)

                // Action Buttons
                HStack {
                    Button(action: reset) {
                        Text("RESET")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.DesignSystem.light100())
                            .foregroundStyle(Color.DesignSystem.secondary900())
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.DesignSystem.secondary900(), lineWidth: 2)
                            )
                    }

                    Button(action: apply) {
                        Text("APPLY")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isApplyButtonEnabled ? Color.DesignSystem.secondary900() : Color.DesignSystem.light300())
                            .foregroundColor(Color.DesignSystem.light100())
                            .cornerRadius(10)
                    }
                    .disabled(!isApplyButtonEnabled)
                }
                .padding()
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 10)
            .offset(y: isPresented ? 0 : UIScreen.main.bounds.height)

            // Close Button
            Button(action: { isPresented = false }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.DesignSystem.secondary900())
                    .padding()
            }
        }
        .padding(.top, 20)
        .onAppear(perform: loadCurrentFilter)  // Load existing filter values on appear
    }

    // Reset the filter to default values
    private func reset() {
        selectedSortOption = nil
        minPrice = ""
        maxPrice = ""
        isAscending = true
        hasInteractedWithPrice = false
        filter = Filter()  // Reset the filter object
    }

    // Apply the selected filter settings
    private func apply() {
        filter.minPrice = Double(minPrice) ?? 0
        filter.maxPrice = Double(maxPrice) ?? 0
        filter.sortOption = selectedSortOption
        filter.isAscending = isAscending

        isPresented.toggle()  // Close the filter view
    }

    // Load the current filter settings into the state variables
    private func loadCurrentFilter() {
        minPrice = filter.minPrice.map { String($0) } ?? ""
        maxPrice = filter.maxPrice.map { String($0) } ?? ""
        selectedSortOption = filter.sortOption
        isAscending = filter.isAscending
    }
}
