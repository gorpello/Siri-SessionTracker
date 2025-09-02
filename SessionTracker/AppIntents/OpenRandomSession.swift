import Foundation
import AppIntents
import SwiftUI

/**
 Opens a random session in the app, great for discovery or when the user can't decide!
 */
struct OpenRandomSession: AppIntent {
    static var title: LocalizedStringResource = "Open Random Session"
    
    static var description = IntentDescription(
        "Opens the app and navigates to a random session from your library.",
        categoryName: "Discover"
    )
    
    static var openAppWhenRun: Bool = true
    
    @Dependency private var navigationModel: NavigationModel
    @Dependency private var sessionManager: SessionDataManager

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetView {
        let allSessions = sessionManager.sessions
        guard let randomSession = allSessions.randomElement() else {
            throw SessionIntentError.sessionNotFound
        }
        navigationModel.selectedCollection = nil
        navigationModel.selectedSession = randomSession
        
        // Provide a custom snippet SwiftUI view for richer Siri/Shortcuts UI
        let snippet = SessionSiriDetailView(session: randomSession)
        
        return .result(
            dialog: "Here's a random session: \(randomSession.name)",
            view: snippet
        )
    }
}
