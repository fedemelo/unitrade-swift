//
//  FormFieldsSection.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 19/11/24.
//


import SwiftUI

struct FormField {
    let label: String
    let binding: Binding<String>
}

struct FormFieldsSection: View {
    let formFields: [FormField]
    let fieldErrors: [String?]
    let focusedField: FocusState<UploadProductView.Field?>.Binding
    let colorScheme: ColorScheme
    let handleFieldChange: (Int, String) -> Void

    var body: some View {
        ForEach(0..<formFields.count, id: \.self) { i in
            FormFieldView(
                label: formFields[i].label,
                binding: formFields[i].binding,
                errorMessage: fieldErrors[i],
                focusedField: focusedField,
                colorScheme: colorScheme,
                onFieldChange: { newValue in
                    handleFieldChange(i, newValue)
                },
                fieldType: formFields[i].label == "Price (COP)" || formFields[i].label == "Rental Period (days)" ? .decimalPad : .default
            )
        }
    }
}
