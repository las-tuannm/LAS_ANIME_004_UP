import Foundation

enum TaqPlayerError {
    case unknown
    case notFound
    case unauthorized
    case authenticationError
    case forbidden
    case unavailable
    case mediaFileError
    case bandwidthExceeded
    case playlistUnchanged
    case decoderMalfunction
    case decoderTemporarilyUnavailable
    case wrongHostIP
    case wrongHostDNS
    case badURL
    case invalidRequest
    case internalServerError
}
