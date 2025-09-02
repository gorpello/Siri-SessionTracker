import AppIntents
import Foundation

struct CreateCollectionIntent: AppIntent {
  
  static var title: LocalizedStringResource = "Create New Collection"
  static var description = IntentDescription(
    "Creates a new collection by name.",
    categoryName: "SessionCollection"
  )
  
  @Parameter(title: "Collection Name")
  var collectionName: String
  
  @Dependency private var sessionManager: SessionDataManager
  
  static var parameterSummary: some ParameterSummary {
    Summary("Create a collection called \(\.$collectionName)")
  }
  
  func perform() async throws -> some IntentResult & ReturnsValue<SessionCollection> & ProvidesDialog {
    let session = sessionManager.addCollection(name: collectionName)
    let dialog = IntentDialog("Created a new collection called \(collectionName).")
    
    return .result(value: session, dialog: dialog)
  }
}
