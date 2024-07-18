//
//  DocumentPicker.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/17.
//

import SwiftUI
import CryptoKit

struct DocumentPicker: View {
    @State private var document: EncryptableDocument?
    @Binding var key: SymmetricKey
    @State private var showDocumentPicker = false
    
    var body: some View {
        VStack {
            Button("Open Document") {
                showDocumentPicker = true
            }
            .padding()
            
            TextField("Encryption Key", text: .constant(keyb64(key)))
            
            if let document = document, let encryptedData = document.encryptedData {
                ShareLink(item: encryptedData, subject: Text("Encrypted File"), preview: SharePreview("Encrypted Data", image: Image(systemName: "lock.doc")))
                    .padding()
            }
            
            Button("Encrypt Document") {
                document?.encryptData(with: key)
            }
            .disabled(document == nil)
            .padding()
            // Try to test decryption
            if document?.encryptedData != nil {
                VStack {
                    Text("Decrypted Data:")
                    Text(String(data: try! decryptData(data: (document?.encryptedData!)!, using: key), encoding: .utf8) ?? "Dec failed")
                }
                
            }
        }
        .fileImporter(
            isPresented: $showDocumentPicker,
            allowedContentTypes: [.plainText],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let files):
                if let file = files.first {
                    // gain access to the directory
                    let gotAccess = file.startAccessingSecurityScopedResource()
                    if !gotAccess { return }
                    // access the directory URL
                    // (read templates in the directory, make a bookmark, etc.)
                    let fileData = try! Data(contentsOf: file)
                    document = EncryptableDocument(data: fileData)
                    // release access
                    file.stopAccessingSecurityScopedResource()
                }
            case .failure(let error):
                // handle error
                print(error)
            }
        }
        
    }
}
