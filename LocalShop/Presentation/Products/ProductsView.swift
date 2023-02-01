import SwiftUI

private struct NavigateToCart: Hashable {}

struct ProductsView: View {
    @StateObject var viewModel: ProductsViewModel
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            List(viewModel.products) { product in
                ProductCell(
                    product: product,
                    onButtonAction: {
                        viewModel.didTap(product: product)
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("products_screen__title")
            .navigationDestination(for: NavigateToCart.self) { _ in
                CartView(viewModel: .init())
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        path.append(NavigateToCart())
                    }) {
                        Assets.Image.cart
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 34, height: 34)
                    }
                }
            }
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

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView(viewModel: .init())
    }
}
