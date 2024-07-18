//
//  ReadAsset.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/17.
//

import Foundation

func readABIString(named fileName: String) -> String? {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        print("ABI file not found.")
        return nil
    }
    
    do {
        let abiString = try String(contentsOf: url, encoding: .utf8)
        return abiString
    } catch {
        print("Failed to read ABI file: \(error)")
        return nil
    }
}

func readByteCode(named fileName: String) -> Data? {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "hex") else {
        print("Bytecode file not found.")
        return nil
    }
    
    do {
        let bytecodeString = try String(contentsOf: url, encoding: .ascii)
        guard let data = Data(hexString: bytecodeString) else {
            print("Invalid bytecode format.")
            return nil
        }
        return data
    } catch {
        print("Failed to read bytecode file: \(error)")
        return nil
    }
}

extension Data {
    init?(hexString: String) {
        let len = hexString.count / 2
        var data = Data(capacity: len)
        var hex = hexString
        if hex.hasPrefix("0x") {
            hex.removeFirst(2)
        }
        for i in 0..<len {
            let j = hex.index(hex.startIndex, offsetBy: i*2)
            let k = hex.index(j, offsetBy: 2)
            let bytes = hex[j..<k]
            if let byte = UInt8(bytes, radix: 16) {
                data.append(byte)
            } else {
                return nil
            }
        }
        self = data
    }
}
