import SwiftUI

struct ListingItemView: View {
    let product: Product

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
                    Image(systemName: "heart")
                        .padding(6)
                        .foregroundColor(Color.DesignSystem.primary900())
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .padding(18)
            }
            
            // Product title
            Text(product.title)
                .font(Font.DesignSystem.bodyText200) // Adjusted for smaller text
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Rating and reviews
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                
                Text(String(format: "%.1f", product.rating))
                    .font(Font.DesignSystem.bodyText200)
                
                Text("(\(product.reviewCount) Reviews)")
                    .font(Font.DesignSystem.bodyText100)
                    .foregroundColor(Color.DesignSystem.light300())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Price
            Text(String(product.price))
                .font(Font.DesignSystem.headline400)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Stock status
            Text(product.isInStock ? "In stock" : "Out of stock")
                .font(Font.DesignSystem.bodyText100)
                .foregroundColor(Color.DesignSystem.primary900())
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(8) // Reduce padding inside the card
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .frame(maxWidth: .infinity)
    }
}
