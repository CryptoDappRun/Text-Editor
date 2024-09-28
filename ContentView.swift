import SwiftUI

import UniformTypeIdentifiers
#if os(macOS)
import AppKit
#endif
struct ContentView: View {
    @State private var notes: String = "" // Editable text
    @State private var isEdited: Bool = false // Track changes for unsaved notes

    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $notes)
                                   .padding()
                                   .font(.system(size: 24)) // Set the font size to 24 points
                                   .border(Color.gray, width: 1)
                                   .onChange(of: notes) { _ in
                                       isEdited = true // Mark as edited whenever text changes
                                   }

                HStack {
                    Button("Save") {
                        saveToFile()
                    }
                    .padding()

                    // Add more buttons if needed
                }
            }
            .navigationTitle("Notes Editor")
            .padding()
        }
    }

    func saveToFile() {
        #if os(macOS)
        // macOS: Use NSSavePanel to choose file location
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [UTType.plainText]
        savePanel.nameFieldStringValue = "Untitled.txt" // Default file name
        
        savePanel.begin { result in
            if result == .OK, let url = savePanel.url {
                do {
                    try notes.write(to: url, atomically: true, encoding: .utf8)
                    isEdited = false // Reset edited status after saving
                } catch {
                    print("Error saving file: \(error.localizedDescription)")
                }
            }
        }
        #else
        // iOS: Use UIActivityViewController
                let activityController = UIActivityViewController(activityItems: [notes], applicationActivities: nil)
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootViewController = windowScene.windows.first?.rootViewController {
                    rootViewController.present(activityController, animated: true)
                }
        #endif
    }
}
