import SwiftUI
import Kingfisher

struct AvatarView: View {
    let url: URL?
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Unwrap(url) { value in
            KFImage.url(url)
                .placeholder {
                    Image(systemName: "slowmo")
                        .foregroundColor(Assets.Color.primary)
                        .font(.system(size: height))
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
        }
    }
}
