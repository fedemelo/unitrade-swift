import SwiftUI

struct ListingItemView: View {
    var body: some View {
        VStack(spacing: 5) {
            ZStack(alignment: .topTrailing) {
                // Image placeholder (square)
                Rectangle()
                    .aspectRatio(1.0, contentMode: .fit) // Ensures square image
                    .foregroundColor(Color.DesignSystem.light200()) // Placeholder color
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                // Heart Icon
                Button(action: {
                    // Add to favorite action
                }) {
                    Image(systemName: "heart") // Use filled heart for better visual consistency
                        .padding(6)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .padding(18)
            }
            
            // Product title
            Text("Bata de Laboratorio - Talla M")
                .font(Font.DesignSystem.bodyText200) // Adjusted for smaller text
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Rating and reviews
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                
                Text("5")
                    .font(Font.DesignSystem.bodyText200) // Reduced font size
                
                Text("(10 Reviews)")
                    .font(Font.DesignSystem.bodyText100) // Smaller subtext for reviews
                    .foregroundColor(Color.DesignSystem.light300())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Price
            Text("$40.000")
                .font(Font.DesignSystem.headline400) // Adjust for smaller font
                .fontWeight(.bold) // Ensure bold appearance
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Stock status
            Text("In stock")
                .font(Font.DesignSystem.bodyText100) // Smaller status font
                .foregroundColor(Color.DesignSystem.primary900())
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(8) // Reduce padding inside the card
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ListingItemView()	
}
