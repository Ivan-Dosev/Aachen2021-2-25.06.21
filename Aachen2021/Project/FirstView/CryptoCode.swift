//
//  CryptoCode.swift
//  Aachen2021
//
//  Created by Ivan Dimitrov on 10.05.21.
//

import CryptoKit
import Foundation

struct Mara: Codable  {
    var ephmeralPublicKeyData: Data
    var ciphertext           : Data
    var signature            : Data
}
// Create a salt for key derivation.
let protocolSalt = "CryptoKit".data(using: .utf8)!

/// Generates an ephemeral key agreement key and performs key agreement to get the shared secret and derive the symmetric encryption key.
func encrypt(_ data: Data, to theirEncryptionKey: Curve25519.KeyAgreement.PublicKey, signedBy ourSigningKey: Curve25519.Signing.PrivateKey) throws -> Data {
        let ephemeralKey = Curve25519.KeyAgreement.PrivateKey()
        let ephemeralPublicKey = ephemeralKey.publicKey.rawRepresentation
        
        let sharedSecret = try ephemeralKey.sharedSecretFromKeyAgreement(with: theirEncryptionKey)
        
        let symmetricKey = sharedSecret.hkdfDerivedSymmetricKey(using: SHA256.self,
                                                                salt: protocolSalt,
        sharedInfo: ephemeralPublicKey + theirEncryptionKey.rawRepresentation + ourSigningKey.publicKey.rawRepresentation,
                                                                outputByteCount: 32)
    print(ephemeralPublicKey.hashValue)
        let ciphertext = try ChaChaPoly.seal(data, using: symmetricKey).combined
        let signature = try ourSigningKey.signature(for: ciphertext + ephemeralPublicKey + theirEncryptionKey.rawRepresentation)
        
        let encode = Mara(ephmeralPublicKeyData: ephemeralPublicKey, ciphertext: ciphertext, signature: signature)
        let encodeData = try! JSONEncoder().encode(encode)
     return encodeData
}

enum DecryptionErrors: Error {
    case authenticationError
}

/// Generates an ephemeral key agreement key and the performs key agreement to get the shared secret and derive the symmetric encryption key.
func decrypt(_ dataModel: Data,
             using ourKeyEncryptionKey: Curve25519.KeyAgreement.PrivateKey,
             from theirSigningKey: Curve25519.Signing.PublicKey) throws -> Data {
    
  let sealedMessage = try! JSONDecoder().decode(Mara.self, from: dataModel)

    let data = sealedMessage.ciphertext + sealedMessage.ephmeralPublicKeyData + ourKeyEncryptionKey.publicKey.rawRepresentation
    guard theirSigningKey.isValidSignature(sealedMessage.signature, for: data) else {
        throw DecryptionErrors.authenticationError
    }
    
    let ephemeralKey = try Curve25519.KeyAgreement.PublicKey(rawRepresentation: sealedMessage.ephmeralPublicKeyData)
    let sharedSecret = try ourKeyEncryptionKey.sharedSecretFromKeyAgreement(with: ephemeralKey)
    
    let symmetricKey = sharedSecret.hkdfDerivedSymmetricKey(using: SHA256.self,
                                                            salt: protocolSalt,
                                                            sharedInfo: ephemeralKey.rawRepresentation + ourKeyEncryptionKey.publicKey.rawRepresentation + theirSigningKey.rawRepresentation,
                                                                                                                outputByteCount: 32)
    print(ephemeralKey.rawRepresentation.hashValue)
    let sealedBox = try! ChaChaPoly.SealedBox(combined: sealedMessage.ciphertext)
    
//    return try ChaChaPoly.open(sealedBox, using: symmetricKey)
    guard let unwrap = try? ChaChaPoly.open(sealedBox, using: symmetricKey) else { print("TUK4"); throw DecryptionErrors.authenticationError}
//    print("The following message was successfully decrypted: \(String(data: unwrap, encoding: .utf8)!)")
      return unwrap
}
/*
 let message = "I'm building a terrific new app!".data(using: .utf8)!
 
 let senderSigningKey = Curve25519.Signing.PrivateKey()
 let senderSigningPublicKey = senderSigningKey.publicKey
 /*:
  Create the receiver's encryption key.
  */
 let receiverEncryptionKey = Curve25519.KeyAgreement.PrivateKey()
 let receiverEncryptionPublicKey = receiverEncryptionKey.publicKey
 /*:
  The sender encrypts the message using the receiver’s public encryption key, and signs with the sender’s private signing key.
  */
 let sealedMessage = try! encrypt(message, to: receiverEncryptionPublicKey, signedBy: senderSigningKey)
 /*:
  The receiver decrypts the message with the private encryption key, and verifies the signature with the sender’s public signing key.
  */
 let decryptedMessage = try? decrypt(sealedMessage, using: receiverEncryptionKey, from: senderSigningPublicKey)
 print("The following message was successfully decrypted: \(String(data: decryptedMessage!, encoding: .utf8)!)")
 */
