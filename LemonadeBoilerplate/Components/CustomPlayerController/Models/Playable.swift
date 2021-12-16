//
//  Playable.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 12.12.2021.
//

enum PlayerSourceType {
    case audio
    case video
}

struct PlayerSourceCreator {
    var name: String
    var description: String?
    var imageURL: String?
    var thumbmailURL: String?
}
struct PlayerSource {
    var imageURL: String
    var thumbmailURL: String
    var sourceURL: String
}

protocol Playable {
    var type: PlayerSourceType { get set }
    var name: String { get set }
    var description: String? { get set }
    var source: PlayerSource { get set }
    var creator: PlayerSourceCreator? { get set }
}
