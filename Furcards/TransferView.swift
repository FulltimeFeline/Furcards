//
//  TransferView.swift
//  Furcards
//
//  Export/import for switching phones. One passphrase-encrypted .furcards
//  file (cross-platform format from furcards-core) carrying the identity,
//  card, and whole collection. Interoperable with the Android app.
//

import SwiftUI
import UniformTypeIdentifiers

struct TransferView: View {
    @Environment(AppModel.self) private var model
    @State private var passphrase = ""
    @State private var status: String?
    @State private var exportURL: URL?
    @State private var showImporter = false

    var body: some View {
        Form {
            Section {
                SecureField("Passphrase (8+ characters)", text: $passphrase)
            } footer: {
                Text("Moving to a new phone — even between iPhone and Android? Export everything (your identity, card and collection) into one encrypted file, then import it on the other device.")
            }

            Section {
                Button {
                    export()
                } label: {
                    Label("Export everything…", systemImage: "square.and.arrow.up")
                }
                .disabled(passphrase.count < 8)

                Button {
                    showImporter = true
                } label: {
                    Label("Import a Furcards file…", systemImage: "square.and.arrow.down")
                }
                .disabled(passphrase.count < 8)
            } footer: {
                Text(status ?? "Importing merges the file's collection into this device's and replaces your identity and card with the file's.")
            }

            if let exportURL {
                Section {
                    ShareLink(item: exportURL) {
                        Label("Share the export file", systemImage: "paperplane")
                    }
                } footer: {
                    Text("Keep the file and passphrase safe — together they are your whole account.")
                }
            }
        }
        .navigationTitle("Export & Transfer")
        .navigationBarTitleDisplayMode(.inline)
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [.data]) { result in
            switch result {
            case let .success(url):
                importFile(at: url)
            case .failure:
                status = "Couldn't open that file."
            }
        }
    }

    private func export() {
        do {
            let data = try model.exportBundle(passphrase: passphrase)
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("furcards-export.furcards")
            try data.write(to: url, options: .atomic)
            exportURL = url
            status = "Exported. Share or save the file below."
        } catch {
            status = "Export failed: \(error.localizedDescription)"
        }
    }

    private func importFile(at url: URL) {
        let scoped = url.startAccessingSecurityScopedResource()
        defer { if scoped { url.stopAccessingSecurityScopedResource() } }
        guard let data = try? Data(contentsOf: url) else {
            status = "Couldn't read that file."
            return
        }
        status = model.importBundle(data, passphrase: passphrase)
            ? "Imported! Your identity, card and collection are restored."
            : "Wrong passphrase, or not a Furcards export."
    }
}
