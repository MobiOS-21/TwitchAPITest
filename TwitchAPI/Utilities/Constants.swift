//
//  Constants.swift
//  TwitchAPI
//
//  Created by Александр Дергилёв on 30.01.2021.
//

import Foundation


let TWITCH_BASE_URL = "https://api.twitch.tv/kraken"
let TWITCH_URL_TOP_GAMES = "/games/top"
let HEADER_ACCEPT_VALUE = "application/vnd.twitchtv.v5+json"
let CLIENT_ID_VALUE = "jorpa8y46w9p6eo9acdt12tnobd4m6"

typealias DownloadComplete = (_ games: [Game]?, _ status: Bool, _ message: String) -> Void
