//
//  CoreInterop.swift
//  Furcards
//
//  Bridging between Foundation and the FurcardsCore (Kotlin Multiplatform)
//  framework. Protocol logic lives in the core; Swift only converts
//  representations at the boundary.
//

import Foundation
import FurcardsCore

extension Data {
    /// Copies this data into the Kotlin byte array type the core APIs take.
    var kotlinByteArray: KotlinByteArray {
        let array = KotlinByteArray(size: Int32(count))
        for (index, byte) in enumerated() {
            array.set(index: Int32(index), value: Int8(bitPattern: byte))
        }
        return array
    }

    init(_ bytes: KotlinByteArray) {
        var data = Data(capacity: Int(bytes.size))
        for index in 0..<bytes.size {
            data.append(UInt8(bitPattern: bytes.get(index: index)))
        }
        self = data
    }

    var hexString: String {
        map { String(format: "%02x", $0) }.joined()
    }

    init?(hexString: String) {
        guard hexString.count.isMultiple(of: 2) else { return nil }
        var data = Data(capacity: hexString.count / 2)
        var index = hexString.startIndex
        while index < hexString.endIndex {
            let next = hexString.index(index, offsetBy: 2)
            guard let byte = UInt8(hexString[index..<next], radix: 16) else { return nil }
            data.append(byte)
            index = next
        }
        self = data
    }
}

extension KotlinByteArray {
    var data: Data { Data(self) }
}

extension Data {
    /// URL-safe unpadded base64: the advertising local-name form of the
    /// ephemeral ID (hex + a 128-bit service UUID overflow the packet).
    var base64url: String {
        base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }

    init?(base64url: String) {
        var padded = base64url
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        while padded.count % 4 != 0 { padded += "=" }
        guard let data = Data(base64Encoded: padded) else { return nil }
        self = data
    }
}
