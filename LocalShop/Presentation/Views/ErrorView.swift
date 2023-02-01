import SwiftUI

struct ErrorView: ViewModifier {
    var isPresented: Binding<Bool>
    var dismissAction: () -> ()

    func body(content: Content) -> some View {
        content
            .alert(
                Text("error_alert__title"),
                isPresented: isPresented
            ) {
                Button(action: {
                    dismissAction()
                }, label: {
                    Text("error_alert__cta")
                })
            } message: {
                Text("error_alert__message")
            }
    }
}

extension View {
    func error(isPresented: Binding<Bool>, dismissAction: @escaping () -> ()) -> some View {
        ModifiedContent(
            content: self,
            modifier: ErrorView(isPresented: isPresented, dismissAction: dismissAction)
        )
    }
}
