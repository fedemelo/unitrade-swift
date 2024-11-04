import SwiftUI

struct UserProductItemView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: UserProductViewModel

    var body: some View {
        HStack(spacing: 15) {
            // Product Image
            ZStack {
                if let imageUrl = viewModel.imageUrl, !imageUrl.isEmpty {
                    AsyncImage(url: URL(string: imageUrl)) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .foregroundColor(Color.DesignSystem.light200(for: colorScheme))
                                .overlay(ProgressView())
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        case .failure:
                            Rectangle()
                                .foregroundColor(.gray)
                                .overlay(Image(systemName: "photo").foregroundColor(.white))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Rectangle()
                        .foregroundColor(Color.DesignSystem.light200(for: colorScheme))
                        .overlay(Image(systemName: "photo").foregroundColor(.white))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .frame(width: 80, height: 80)

            VStack(alignment: .leading, spacing: 5) {
                // Save count
                Text("\(viewModel.saveCount)")
                    .font(Font.DesignSystem.headline700)
                    .foregroundColor(Color.DesignSystem.primary900(for: colorScheme)) +
                Text(" Views")
                    .font(Font.DesignSystem.bodyText200)
                    .foregroundColor(Color.DesignSystem.primary600(for: colorScheme))

                // Product title
                Text(viewModel.title)
                    .font(Font.DesignSystem.bodyText200)
                    .lineLimit(1)
                    .foregroundColor(Color.DesignSystem.primary900(for: colorScheme))

                // Product price
                Text(viewModel.formattedPrice)
                    .font(Font.DesignSystem.headline400)
                    .foregroundColor(Color.DesignSystem.contrast900(for: colorScheme))

                // Product type (e.g., "Shipped")
                if viewModel.type != nil {
                    Text(viewModel.type!)
                        .font(Font.DesignSystem.bodyText200)
                        .foregroundColor(.yellow)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.yellow.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.DesignSystem.light200(for: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 2)
    }
}
