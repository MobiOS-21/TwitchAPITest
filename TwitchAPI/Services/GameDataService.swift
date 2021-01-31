//
//  GameDataService.swift
//  TwitchAPI
//
//  Created by Александр Дергилёв on 30.01.2021.
//

import Foundation
import Alamofire

class GameDataService {
    static let instance = GameDataService()
    var callBack: DownloadComplete?
    private var offset = 0
    
    private(set) var loadNextGames: Bool = true
    func downloadTopGames(limit: Int, with pagination: Bool) {
        if pagination == false { offset = 0 }
        loadNextGames = true
        let url = TWITCH_BASE_URL + TWITCH_URL_TOP_GAMES
        let headers: HTTPHeaders = [HTTPHeader(name: "Accept", value: HEADER_ACCEPT_VALUE),
                                   HTTPHeader(name: "Client-ID", value: CLIENT_ID_VALUE)]
        let parameters: Parameters = ["limit": limit, "offset": offset]
        AF.request(url, method: .get, parameters: parameters, headers: headers).response { responseData in
            guard let data = responseData.data else {
                self.callBack?(nil, false, "")
                return
            }
            do {
                let games = try JSONDecoder().decode(TopGamesResponse.self, from: data)
                self.offset += games.games?.count ?? 0
                self.loadNextGames = false
                self.callBack?(games.games, true, "")
            } catch {
                self.callBack?(nil, false, error.localizedDescription)
            }
        }
    }
    
    func completionHandler(callBack: @escaping DownloadComplete) {
        self.callBack = callBack
    }
}
