import SwiftUI

struct ProductCell: View {
    @State var product: Product
    @State var isSelected: Bool = false
    var onButtonAction: () -> (Bool)
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                AvatarView(
                    url: product.thumbnail,
                    width: 80,
                    height: 80
                )
            }
            .padding(8)
            VStack(alignment: .leading, spacing: 5) {
                Text(product.title)
                    .fontWeight(.bold)
                    .padding(.top, 8)
                    .foregroundColor(Assets.Color.primary)
                Text(product.priceString)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 16)
            Spacer()
            VStack {
                Button {
                    isSelected = onButtonAction()
                } label: {
                    Image(systemName: "heart.fill")
                }
                .foregroundColor(isSelected ? Assets.Color.button : Assets.Color.primary)
                .frame(width: 50, height: 50)
            }
        }
    }
}

struct ProductCell_Previews: PreviewProvider {
    static var previews: some View {
        ProductCell(product: .fixture(), onButtonAction: { true })
    }
}
