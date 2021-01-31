//
//  Game.swift
//  TwitchAPI
//
//  Created by Александр Дергилёв on 30.01.2021.
//

import UIKit
import Alamofire


class TopGamesResponse: Decodable {
    let games: [Game]?
    enum CodingKeys: String, CodingKey {
        case games = "top"
    }
    
    init(games: [Game]?) {
        self.games = games
    }
}

class Game: Decodable {
    let viewers, channels: Int?
    let name, logoUrl: String?
    
    init(viewers: Int?, channels: Int?, name: String?, logoUrl: String?) {
        self.viewers = viewers
        self.channels = channels
        self.name = name
        self.logoUrl = logoUrl
    }
    enum CodingKeys: String, CodingKey {
        case game
        case viewers
        case channels
    }
    enum GameCodingKeys: String, CodingKey {
        case name
        case logo
    }
    enum LogoCodingKeys: String, CodingKey {
        case large
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.viewers = try? container.decode(Int.self, forKey: .viewers)
        self.channels = try? container.decode(Int.self, forKey: .channels)
        
        let gameContainer = try? container.nestedContainer(keyedBy: GameCodingKeys.self, forKey: .game)
        self.name = try? gameContainer?.decode(String.self, forKey: .name)

        let logoContainer = try? gameContainer?.nestedContainer(keyedBy: LogoCodingKeys.self, forKey: .logo)
        self.logoUrl = try? logoContainer?.decode(String.self, forKey: .large)
    }
}
