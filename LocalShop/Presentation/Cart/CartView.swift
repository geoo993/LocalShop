import SwiftUI

struct CartView: View {
    @StateObject var viewModel: CartViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            List(viewModel.products) { product in
                CartCell(
                    product: product,
                    units: product.quantity,
                    onUpdateItemUnit: { units in
                        viewModel.didUpdate(product: product, units: units)
                    }
                )
                .listRowInsets(
                    EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
                )
                .listRowSeparator(.hidden)
                .background(Assets.Color.background)
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
            .listStyle(PlainListStyle())
            .navigationTitle("cart_screen__title")
            Divider()
            Text(viewModel.cartValue)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Assets.Color.primary)
        }
        .onAppear {
            viewModel.loadProducts()
        }
        .error(
            isPresented: Binding(
                get: { viewModel.showErrorMessage }, set: { _,_ in }
            ),
            dismissAction: viewModel.dismissAlert
        )
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(viewModel: .init())
    }
}
