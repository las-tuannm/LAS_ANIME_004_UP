import CryptoSwift

extension NSError {
    static func make(code: Int, userInfo: [String : Any]? = nil) -> NSError {
        return NSError(domain: "org.cocoapods.SwiftyAds", code: code, userInfo: userInfo)
    }
}

// AES-CBC-128
class TaqAESObject: NSObject {
    private let iv = "6f9bbc19f78f980f"
    private let key = "cb4b10abaadd1e422b15ff7586307842"
    
    func encrypt(_ s: String) throws -> String {
        guard let data = s.data(using: .utf8) else {
            throw NSError.make(code: 1000, userInfo: ["message": "String cannot be converted to .utf8 data"])
        }
        
        let bytes = [UInt8](data)
        let encrypted = try AES(key: key, iv: iv, padding: .pkcs7).encrypt(bytes)
        return Data(encrypted).base64EncodedString()
    }
    
    func decrypt(_ s: String) throws -> String? {
        guard let data = Data(base64Encoded: s) else {
            throw NSError.make(code: 1001, userInfo: ["message": "String cannot be converted to base64 data"])
        }
        
        let bytes = [UInt8](data)
        let decrypted = try AES(key: key, iv: iv, padding: .pkcs7).decrypt(bytes)
        return String(bytes: decrypted, encoding: .utf8)
    }
}

