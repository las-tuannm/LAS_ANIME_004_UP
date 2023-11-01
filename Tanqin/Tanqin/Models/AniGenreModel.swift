import UIKit

struct AniGenreModel: Codable {
    let name: String
    let detailLink: String
    var startColor: Int? = nil
    var endColor: Int? = nil
}

extension AniGenreModel {
    var detailURL: URL? {
        return URL(string: detailLink)
    }
}
