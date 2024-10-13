import SwiftUI

struct PriceRangeView: View {
    @Binding var minPrice: String
    @Binding var maxPrice: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Price Range")
                .font(Font.DesignSystem.headline600)
                .padding(.leading)
                .foregroundStyle(Color.DesignSystem.secondary900())

            HStack {
                Spacer()
                
                // Min Price TextField
                VStack(alignment: .leading) {
                    Text("Min Price")
                        .font(Font.DesignSystem.bodyText200)
                        .foregroundStyle(Color.DesignSystem.primary600())
                    NumericTextField(
                        text: $minPrice,
                        placeholder: "Min",
                        allowsDecimal: true,
                        font: Font.DesignSystem.bodyText300,
                        textColor: Color.DesignSystem.primary600(),
                        placeholderFont: Font.DesignSystem.bodyText200,
                        placeholderColor: Color.DesignSystem.light300()
                    )
                    .padding(.vertical,10)
                    .padding(.horizontal, 10)
                    .background(Color.DesignSystem.light200())
                    .cornerRadius(8)
                    .frame(width: 100,height: 50)
                }.padding(.horizontal,15)

                

                // Max Price TextField
                VStack(alignment: .leading) {
                    Text("Max Price")
                        .font(Font.DesignSystem.bodyText200)
                        .foregroundStyle(Color.DesignSystem.primary600())
                    NumericTextField(
                        text: $maxPrice,
                        placeholder: "Max",
                        allowsDecimal: true,
                        font: Font.DesignSystem.bodyText300,
                        textColor: Color.DesignSystem.primary600(),
                        placeholderFont: Font.DesignSystem.bodyText200,
                        placeholderColor: Color.DesignSystem.light300()
                    )
                    .padding(.vertical,10)
                    .padding(.horizontal, 10)
                    .background(Color.DesignSystem.light200())
                    .cornerRadius(8)
                    .frame(width: 100,height: 50)
                }.padding(.horizontal,15)
                Spacer()
            }
            .padding()
        }
    }
}

