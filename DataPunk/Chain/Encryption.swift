//
//  Encryption.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/17.
//

import SwiftUI
import CryptoKit
import UniformTypeIdentifiers

enum EncryptionError: Error {
    case encryptionFailed
}

/*encryptFile*/
fileprivate func encryptFile(atPath path: String, using key: SymmetricKey, outputPath: String) throws {
    let data = try Data(contentsOf: URL(fileURLWithPath: path))
    let sealedBox = try AES.GCM.seal(data, using: key)
    guard let encryptedData = sealedBox.combined else {
        throw EncryptionError.encryptionFailed
    }
    
    try encryptedData.write(to: URL(fileURLWithPath: outputPath))
}

/*decryptFile*/
fileprivate func decryptFile(atPath path: String, using key: SymmetricKey, outputDecryptedPath: String) throws {
    let encryptedData = try Data(contentsOf: URL(fileURLWithPath: path))
    _ = try AES.GCM.Nonce(data: encryptedData.prefix(12))
//    let ciphertext = encryptedData.suffix(from: encryptedData.index(encryptedData.startIndex, offsetBy: 12))
    let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
    let decryptedData = try AES.GCM.open(sealedBox, using: key)
    
    try decryptedData.write(to: URL(fileURLWithPath: outputDecryptedPath))
    print("Decrypted file saved to \(outputDecryptedPath)")
}

// decrypt data
func decryptData(data: Data, using key: SymmetricKey) throws -> Data {
    let sealedBox = try AES.GCM.SealedBox(combined: data)
    return try AES.GCM.open(sealedBox, using: key)
}

func unserializeKey(from base64: String) -> SymmetricKey {
    let data = Data(base64Encoded: base64)!
    return SymmetricKey(data: data)
}

func keyb64(_ key: SymmetricKey) -> String {
    return key.withUnsafeBytes {
        return Data(Array($0)).base64EncodedString()
    }
}

struct EncryptableDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.plainText] } // Adjust based on the file types you expect
    
    var data: Data
    var encryptedData: Data?
    
    init(data: Data) {
        self.data = data
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.data = data
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard let encryptedData = encryptedData else {
            throw CocoaError(.fileWriteUnknown)
        }
        return .init(regularFileWithContents: encryptedData)
    }
    
    mutating func encryptData(with key: SymmetricKey) {
        do {
            let sealedBox = try AES.GCM.seal(data, using: key)
            self.encryptedData = sealedBox.combined
        } catch {
            print("Encryption failed: \(error)")
        }
    }
}
