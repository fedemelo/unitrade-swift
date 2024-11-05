import SwiftUI

struct ListingItemView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: ListingItemViewModel  // Bind to ViewModel
    @StateObject private var screenTimeViewModel = ScreenTimeViewModel()
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack(alignment: .topTrailing) {
                // Image container
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 150, height: 150)
                    .overlay(
                        Group {
                            if viewModel.imageUrl == "dummy" {
                                Rectangle()
                                    .foregroundColor(Color.DesignSystem.light200(for: colorScheme))
                                    .overlay(
                                        Image(systemName: "photo")
                                            .font(.largeTitle)
                                            .foregroundColor(.white)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            } else {
                                AsyncImage(url: URL(string: viewModel.imageUrl ?? "")) { phase in
                                    switch phase {
                                    case .empty:
                                        Rectangle()
                                            .foregroundColor(Color.DesignSystem.light200(for: colorScheme))
                                            .overlay(ProgressView())
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 150, height: 150)
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                    case .failure:
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
                
                // Favorite button
                Button(action: {
                    viewModel.toggleFavorite()
                }) {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .padding(6)
                        .foregroundColor(Color.DesignSystem.primary900(for: colorScheme))
                        .background(Color.DesignSystem.whitee(for: colorScheme))
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .padding(8)
            }
            
            // Product title
            Text(viewModel.title)
                .font(Font.DesignSystem.bodyText200)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .frame(maxWidth: .infinity, minHeight: 35, alignment: .leading)
            
            // Rating and reviews
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text(viewModel.formattedRating)
                    .font(Font.DesignSystem.bodyText200)
                Text(viewModel.reviewText)
                    .font(Font.DesignSystem.bodyText100)
                    .foregroundColor(Color.DesignSystem.light300(for: colorScheme))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Formatted price
            Text(viewModel.getDecoratedPrice())
                .font(Font.DesignSystem.headline400)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Stock status
            Text(viewModel.stockStatus)
                .font(Font.DesignSystem.bodyText100)
                .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() : Color.DesignSystem.primary600())
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(8)
        .background(Color.DesignSystem.whitee(for: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .frame(maxWidth: .infinity)
    }
}
