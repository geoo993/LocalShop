import SwiftUI

private struct NavigateToCart: Hashable {}

struct ProductsView: View {
    @StateObject var viewModel: ProductsViewModel
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(viewModel.products) { product in
                    ListView(product: product) {
                        viewModel.didTap(product: product)
                    }
                    if product == viewModel.products.last {
                        ProgressView()
                            .onAppear {
                                viewModel.loadNextProducts()
                            }
                    }
                }
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

struct ListView: View {
    @State var product: Product
    var didTapHandler: () -> (Bool)
    
    var body: some View {
        ProductCell(
            product: product,
            onButtonAction: {
                didTapHandler()
            }
        )
        .listRowInsets(
            EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        )
        .listRowSeparator(.hidden)
        .background(Assets.Color.background)
        .cornerRadius(12)
    }
}

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView(viewModel: .init())
    }
}
