import SwiftUI

struct TodayView: View {
    var body: some View {
        Text("Flow")
            .font(FlowTypography.screenTitle)
            .foregroundStyle(FlowColors.primaryText)
            .accessibilityAddTraits(.isHeader)
            .padding(FlowSpacing.pageInset)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(FlowColors.background.ignoresSafeArea())
    }
}
