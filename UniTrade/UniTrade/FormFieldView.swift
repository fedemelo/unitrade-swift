//
//  FormFieldView.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 19/11/24.
//

import SwiftUI

struct FormFieldView: View {
    let label: String
    @Binding var binding: String
    let errorMessage: String?
    let focusedField: FocusState<UploadProductView.Field?>.Binding
    let colorScheme: ColorScheme
    let onFieldChange: (String) -> Void
    let fieldType: UIKeyboardType

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label)
                .font(Font.DesignSystem.bodyText200)

            TextField("", text: $binding)
                .onChange(of: binding) { _,newValue in
                    onFieldChange(newValue)
                }
                .textFieldStyle(.plain)
                .font(Font.DesignSystem.bodyText100)
                .keyboardType(fieldType)
                .focused(focusedField, equals: label.toField())
                .onTapGesture {
                    focusedField.wrappedValue = label.toField()
                }
                .padding(.bottom, -5)

            Divider().background(errorMessage != nil ? Color.red : Color.DesignSystem.dark800(for: colorScheme))

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, -5)
            }
        }
    }
}


private extension String {
    func toField() -> UploadProductView.Field {
        switch self {
        case "Name": return .name
        case "Description": return .description
        case "Price (COP)": return .price
        case "Rental Period (days)": return .rentalPeriod
        case "Condition": return .condition
        default: return .name
        }
    }
}
