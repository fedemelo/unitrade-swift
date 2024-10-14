import SwiftUI

struct ListingItemView: View {
    @Environment(\.colorScheme) var colorScheme
    let product: Product

    var body: some View {
        VStack(spacing: 5) {
            ZStack(alignment: .topTrailing) {
                // Conditional AsyncImage logic
                if product.imageUrl == "dummy.png" {
                    // Display the gray placeholder directly
                    Rectangle()
                        .foregroundColor(Color.DesignSystem.light200(for: colorScheme))
                        .overlay(
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    // Load product image using AsyncImage
                    AsyncImage(url: URL(string: product.imageUrl ?? "")) { phase in
                        switch phase {
                        case .empty:
                            // Loading placeholder
                            Rectangle()
                                .foregroundColor(Color.DesignSystem.light200(for: colorScheme))
                                .overlay(
                                    ProgressView()  // Loading indicator
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        case .success(let image):
                            // Loaded Image
                            image
                                .resizable()
                                .aspectRatio(1.0, contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .frame(maxWidth: .infinity)
                        case .failure:
                            // Error placeholder
                            Rectangle()
                                .foregroundColor(.gray)
                                .overlay(
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        @unknown default:
                            EmptyView()
                        }
                    }
                }

                // Heart Icon Button
                Button(action: {
                    // Add to favorite action
                }) {
                    Image(systemName: "heart")
                        .padding(6)
                        .foregroundColor(Color.DesignSystem.primary900(for: colorScheme))
                        .background(Color.DesignSystem.whitee(for: colorScheme))
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .padding(18)
            }

            // Product Title
            Text(product.title)
                .font(Font.DesignSystem.bodyText200)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .frame(maxWidth: .infinity, minHeight: 35, alignment: .leading)

            // Rating and Reviews
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text(String(format: "%.1f", product.rating))
                    .font(Font.DesignSystem.bodyText200)
                Text("(\(product.reviewCount) Reviews)")
                    .font(Font.DesignSystem.bodyText100)
                    .foregroundColor(Color.DesignSystem.light300(for: colorScheme))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Price
            Text(String(format: "COP %.0f", product.price))
                .font(Font.DesignSystem.headline400)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Stock Status
            Text(product.isInStock == "lease" ? "For Rent" : "For Sale")
                .font(Font.DesignSystem.bodyText100)
                .foregroundColor(Color.DesignSystem.primary900(for: colorScheme))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(8)
        .background(Color.DesignSystem.whitee(for: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .frame(maxWidth: .infinity)
    }
}
