import SwiftUI

struct NumericTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var allowsDecimal: Bool

    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = allowsDecimal ? 2 : 0
        return formatter
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.keyboardType = allowsDecimal ? .decimalPad : .numberPad
        textField.delegate = context.coordinator  // Set delegate for input validation
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text  // Keep the text in sync with the binding
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: NumericTextF
