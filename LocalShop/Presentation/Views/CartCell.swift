import SwiftUI

struct CartCell: View {
    @State var product: Product
    @State var units: Int
    var onUpdateItemUnit: (Int) -> ()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                AvatarView(
                    url: product.thumbnail,
                    width: 80,
                    height: 60
                )
            }
            .padding(8)
            VStack(alignment: .leading, spacing: 8) {
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
            VStack(spacing: 8) {
                Button {
                    if units < product.stock {
                        units += 1
                        onUpdateItemUnit(units)
                    }
                } label: {
                    Image(systemName: "plus.rectangle")
                }
                .foregroundColor(Assets.Color.button)
                Text("\(units)")
                    .lineLimit(1)
                    .foregroundColor(Assets.Color.primary)
                
                Button {
                    if units > 0 {
                        units -= 1
                        onUpdateItemUnit(units)
                    }
                } label: {
                    Image(systemName: "minus.rectangle")
                }
                .foregroundColor(Assets.Color.button)
            }.padding(8)
        }
    }
}

struct CartCell_Previews: PreviewProvider {
    static var previews: some View {
        CartCell(product: .fixture(), units: 1, onUpdateItemUnit: { _ in })
    }
}
