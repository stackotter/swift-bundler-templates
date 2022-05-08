import SwiftUI

class TriangleViewModel: ObservableObject {
  @Published var error: String? = nil
  
  func handleError(_ error: String) {
    DispatchQueue.main.async {
      self.error = error
    }
  }
}

struct TriangleView: View {
  @ObservedObject var model = TriangleViewModel()

  var body: some View {
    if let error = model.error {
      Text(error)
    } else {
      MetalView(
        rendererType: TriangleRenderer.self,
        errorHandler: model.handleError(_:)
      )
    }
  }
}
