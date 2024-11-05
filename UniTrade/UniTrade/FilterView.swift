import SwiftUI

struct FilterView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var isPresented: Bool
    @Binding var filter: Filter
    @StateObject private var screenTimeViewModel = ScreenTimeViewModel()
    
    @State private var selectedSortOption: String = ""  // Change to non-optional
    @State private var isAscending: Bool = true
    @State private var minPrice: String = ""
    @State private var maxPrice: String = ""
    @State private var hasInteractedWithPrice = false
    
    @FocusState private var isKeyboardActive: Bool  // Track if a TextField is focused
    
    let sortOptions = ["Rating", "Price"]
    
    private var isApplyButtonEnabled: Bool {
        let minValue = Double(minPrice)
        let maxValue = Double(maxPrice)
        
        let arePricesValid = minValue != nil && maxValue != nil && minValue! <= maxValue!
        let arePricesPartiallyFilled = (minPrice.isEmpty != maxPrice.isEmpty)
        
        return (arePricesValid && !minPrice.isEmpty && !maxPrice.isEmpty) ||
        (!selectedSortOption.isEmpty && !arePricesPartiallyFilled &&
         (arePricesValid || (minPrice.isEmpty && maxPrice.isEmpty)))
    }
    
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
                    .focused($isKeyboardActive)  // Track focus state
                
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
                    .foregroundStyle(Color.DesignSystem.secondary900(for: colorScheme))
                    .padding(.bottom, 10)
                    .padding(.leading)
                
                Picker("Select Sort Option", selection: $selectedSortOption) {
                    ForEach(sortOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .foregroundStyle(Color.DesignSystem.primary900(for: colorScheme))
                
                // Sort Order Toggle
                HStack {
                    Text("Order:")
                        .font(Font.DesignSystem.bodyText300)
                        .foregroundStyle(Color.DesignSystem.primary600(for: colorScheme))
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
                
                // Action Buttons
                HStack {
                    Button(action: reset) {
                        Text("RESET")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.DesignSystem.light100(for: colorScheme))
                            .foregroundStyle(Color.DesignSystem.secondary900(for: colorScheme))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.DesignSystem.secondary900(for: colorScheme), lineWidth: 2)
                            )
                    }
                    
                    Button(action: apply) {
                        Text("APPLY")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isApplyButtonEnabled ? Color.DesignSystem.secondary900(for: colorScheme) : Color.DesignSystem.light300(for: colorScheme))
                            .foregroundColor(Color.DesignSystem.light100(for: colorScheme))
                            .cornerRadius(10)
                    }
                    .disabled(!isApplyButtonEnabled)
                }
                .padding()
            }
            .padding()
            .padding(.bottom, 70)
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 10)
            .offset(y: isPresented ? 0 : UIScreen.main.bounds.height)
            
            HStack {
                if isKeyboardActive {
                    Button("Done") {
                        hideKeyboard()
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.DesignSystem.secondary900(for: colorScheme))
                    .transition(.opacity)  // Smooth appearance and disappearance
                }
                
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.DesignSystem.secondary900(for: colorScheme))
                }
            }
            .padding(.trailing, 15)
            .padding(.top, 10)
        }
        .padding(.top, 20)
        .onAppear {
            loadCurrentFilter()
            screenTimeViewModel.startTrackingTime()
        }
        .onDisappear {screenTimeViewModel.stopAndRecordTime(for: "FilterView")}

    }
    
    // Dismiss the keyboard by unfocusing the TextFields
    private func hideKeyboard() {
        isKeyboardActive = false
    }
    
    private func reset() {
        selectedSortOption = ""  // Reset to empty string
        minPrice = ""
        maxPrice = ""
        isAscending = true
        hasInteractedWithPrice = false
        filter = Filter()
    }
    
    private func apply() {
        filter.minPrice = Double(minPrice) ?? 0
        filter.maxPrice = Double(maxPrice) ?? 0
        filter.sortOption = selectedSortOption.isEmpty ? nil : selectedSortOption
        filter.isAscending = isAscending
        isPresented.toggle()
    }
    
    private func loadCurrentFilter() {
        minPrice = filter.minPrice.map { String($0) } ?? ""
        maxPrice = filter.maxPrice.map { String($0) } ?? ""
        selectedSortOption = filter.sortOption ?? ""  // Use non-optional string
        isAscending = filter.isAscending
    }
}
