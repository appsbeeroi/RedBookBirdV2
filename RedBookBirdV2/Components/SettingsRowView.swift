import SwiftUI

// MARK: - Settings Row View

struct SettingsRowView: View {
    let title: String
    let action: (() -> Void)?
    let trailingContent: AnyView?
    
    init(title: String, action: (() -> Void)? = nil, trailingContent: AnyView? = nil) {
        self.title = title
        self.action = action
        self.trailingContent = trailingContent
    }
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            HStack(spacing: 12) {
                Text(title)
                    .font(.customFont(font: .regular, size: 20))
                    .foregroundStyle(.customBlack)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if let trailingContent = trailingContent {
                    trailingContent
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Toggle Content

struct ToggleContent: View {
    @Binding var isOn: Bool
    let onChange: (Bool) -> Void
    
    var body: some View {
        Toggle("", isOn: $isOn)
            .toggleStyle(SwitchToggleStyle(tint: .yellow))
            .onChange(of: isOn) { value in
                onChange(value)
            }
    }
}

// MARK: - Chevron Content

struct ChevronContent: View {
    var body: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(.yellow)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 12) {
        SettingsRowView(
            title: "Notifications",
            trailingContent: AnyView(ToggleContent(isOn: .constant(true)) {_ in })
        )
        
        SettingsRowView(
            title: "About the application",
            action: { print("About tapped") },
            trailingContent: AnyView(ChevronContent())
        )
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
