import SwiftUI

@main
struct FlowApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                FlowColors.background
                    .ignoresSafeArea()

                TodayView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
