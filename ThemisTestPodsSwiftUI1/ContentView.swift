//
//  ContentView.swift
//  ThemisTestPodsSwiftUI1
//
//  Created by Oleksii Radetskyi on 12.09.2022.
//

import SwiftUI
import themis

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return self.map { String(format: format, $0) }.joined()
    }
}


struct ContentView: View {
    var symmetricKey: String {
        let masterkey = TSGenerateSymmetricKey()
        return masterkey?.hexEncodedString() ?? "Failed"
    }
    
    var keyPair: (String, String) {
        let keypair = TSKeyGen(algorithm: .EC)!
        let privateKey: Data = keypair.privateKey as Data
        let publicKey: Data = keypair.publicKey as Data
        
        let privateKey64 = privateKey.hexEncodedString()
        let publicKey64 = publicKey.hexEncodedString()
        
        return (privateKey64, publicKey64)
    }
    
    let helloText = "Hello, Themis!"
    var encryptedHelloText: String {
        let masterKey = TSGenerateSymmetricKey()!
        let cell = TSCellSeal(key: masterKey)
        let helloTextD = helloText.data(using: .utf8)!
        
        let encrypted: Data = try! cell!.encrypt(helloTextD)

        return encrypted.hexEncodedString()
    }
    
    var body: some View {
        ScrollView {
            Text(helloText)
                .font(.title)
                .padding()
            Text("Symmetric key:")
                .font(.title3)
            Text(symmetricKey)
                .padding(.bottom)
                .padding(.horizontal)
                .monospacedDigit()
            
            Text("Asymmetric keypair").font(.title2)
            Text("Private key:")
                .font(.subheadline)
            Text(keyPair.0).monospacedDigit().padding(.horizontal)
            
            Text("Public key:").font(.subheadline)
            Text(keyPair.1).monospacedDigit().padding(.horizontal).padding(.bottom)
            
            Text("Encrypted example:").font(.title3)
            Text(encryptedHelloText).monospacedDigit().padding(.horizontal)
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
