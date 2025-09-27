import SwiftUI

struct SplashMainView: View {
    
    @EnvironmentObject private var appRouter: AppRouter
    
    var body: some View {
        ZStack(alignment: .center) {
            Image("backGroundSplash")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Text("RedBook\nBird")
                    .multilineTextAlignment(.center)
                
                ProgressView()
                    .scaleEffect(1.5)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 120)
            .font(.system(size: 58, weight: .bold, design: .rounded))
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                appRouter.currentMainScreen = .tabbar
            }
        }
    }
}

// MARK: - Preview

#Preview("LightEN") {
    SplashMainView()
        .environmentObject(AppRouter.shared)
}
