import SwiftUI

@main
struct FlowApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
    }
}

private struct RootTabView: View {
    @State private var selection: AppTab = .today

    var body: some View {
        TabView(selection: $selection) {
            Tab("Today", systemImage: "sun.max", value: .today) {
                TodayView()
            }

            Tab("Inbox", systemImage: "tray", value: .inbox) {
                PlaceholderDestinationView(title: "Inbox")
            }

            Tab("Plan", systemImage: "calendar", value: .plan) {
                PlaceholderDestinationView(title: "Plan")
            }

            Tab("Projects", systemImage: "folder", value: .projects) {
                PlaceholderDestinationView(title: "Projects")
            }

            Tab("AI", systemImage: "sparkles", value: .ai) {
                PlaceholderDestinationView(title: "AI")
            }

            Tab("Settings", systemImage: "gearshape", value: .settings) {
                PlaceholderDestinationView(title: "Settings")
            }
        }
        .tint(FlowColors.accent)
        .background(FlowColors.background.ignoresSafeArea())
    }
}

private enum AppTab: Hashable {
    case today
    case inbox
    case plan
    case projects
    case ai
    case settings
}

private struct PlaceholderDestinationView: View {
    let title: String

    var body: some View {
        VStack(spacing: FlowSpacing.small) {
            Text(title)
                .font(FlowTypography.screenTitle)
                .foregroundStyle(FlowColors.primaryText)
                .accessibilityAddTraits(.isHeader)

            Text("Coming soon")
                .font(FlowTypography.body)
                .foregroundStyle(FlowColors.secondaryText)
        }
        .padding(FlowSpacing.pageInset)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
