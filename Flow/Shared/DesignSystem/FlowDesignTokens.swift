import SwiftUI
import UIKit

enum FlowSpacing {
    static let extraSmall: CGFloat = 4
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let extraLarge: CGFloat = 32

    static let pageInset = large
}

enum FlowTypography {
    static let screenTitle = Font.largeTitle.weight(.semibold)
    static let sectionTitle = Font.title2.weight(.semibold)
    static let body = Font.body
    static let caption = Font.caption
}

enum FlowColors {
    static let primaryText = Color.primary
    static let secondaryText = Color.secondary
    static let background = Color(uiColor: .systemGroupedBackground)
    static let surface = Color(uiColor: .secondarySystemGroupedBackground)
    static let accent = Color.accentColor
}
