import SwiftUI

struct NumericTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var allowsDecimal: Bool

    // Add SwiftUI font and color parameters
    var font: Font = .body
    var textColor: Color = .primary
    var placeholderFont: Font = .caption
    var placeholderColor: Color = .gray

    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = allowsDecimal ? 2 : 0
        return formatter
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.keyboardType = allowsDecimal ? .decimalPad : .numberPad
        textField.delegate = context.coordinator

        // Set font and text color
        textField.font = UIFont(font)
        textField.textColor = UIColor(textColor)

        // Set custom placeholder style
        applyPlaceholderStyle(to: textField)

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text  // Keep the text in sync with the binding
        uiView.font = UIFont(font)
        uiView.textColor = UIColor(textColor)
        applyPlaceholderStyle(to: uiView)  // Ensure placeholder style updates dynamically
    }

    // Helper function to apply placeholder styling
    private func applyPlaceholderStyle(to textField: UITextField) {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor(placeholderColor),
                .font: UIFont(placeholderFont)
            ]
        )
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: NumericTextField

        init(_ parent: NumericTextField) {
            self.parent = parent
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let allowedCharacters = self.parent.allowsDecimal ? "0123456789." : "0123456789"
            let characterSet = CharacterSet(charactersIn: allowedCharacters)

            // Reject any non-numeric input
            if string.rangeOfCharacter(from: characterSet.inverted) != nil {
                return false
            }

            // Prevent multiple decimals
            if string == "." && textField.text?.contains(".") == true {
                return false
            }

            // Update the binding with the new value
            if let text = textField.text as NSString? {
                let updatedText = text.replacingCharacters(in: range, with: string)
                parent.text = updatedText
            }

            return true
        }
    }
}
