import SwiftUI

struct ListingItemView: View {
    @Environment(\.colorScheme) var colorScheme
    let product: Product

    // Helper to format price
    private func formatPrice(_ price: Float) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = "COP $"
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.locale = Locale(identifier: "es_CO")

        return numberFormatter.string(from: NSNumber(value: price)) ?? "COP 0"
    }

    // Helper to format rating
    private func formatRating(_ rating: Float) -> String {
        return rating == 0.0 ? "-" : String(format: "%.1f", rating)
    }

    var body: some View {
        VStack(spacing: 5) {
            ZStack(alignment: .topTrailing) {
                // Fixed-size Image Container (Consistent across all items)
                Rectangle()
                    .foregroundColor(.clear)  // Acts as a container
                    .frame(width: 150, height: 150)  // Consistent size for image and placeholders
                    .overlay(
                        Group {
                            if product.imageUrl == "dummy.png" {
                                // Gray Placeholder with Icon
                                Rectangle()
                                    .foregroundColor(Color.DesignSystem.light200(for: colorScheme))
                                    .overlay(
                                        Image(systemName: "photo")
                                            .font(.largeTitle)
                                            .foregroundColor(.white)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            } else {
                                // AsyncImage Logic
                                AsyncImage(url: URL(string: product.imageUrl ?? "")) { phase in
                                    switch phase {
                                    case .empty:
                                        // Show ProgressView while loading
                                        Rectangle()
                                            .foregroundColor(Color.DesignSystem.light200(for: colorScheme))
                                            .overlay(ProgressView())
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 150, height: 150)  // Ensure consistent size
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                    case .failure:
                                        // Show Placeholder on Failure
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
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                // Favorite Button
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
                Text(formatRating(product.rating))
                    .font(Font.DesignSystem.bodyText200)
                Text("(\(product.reviewCount) Reviews)")
                    .font(Font.DesignSystem.bodyText100)
                    .foregroundColor(Color.DesignSystem.light300(for: colorScheme))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Formatted Price
            Text(formatPrice(product.price))
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
