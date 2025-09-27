import SwiftUI

struct BackGroundView: View {
    var body: some View {
        Image("backGroundView")
            .resizable()
            .ignoresSafeArea()
    }
}

// MARK: - Preview

#Preview("LightEN") {
    BackGroundView()
}
