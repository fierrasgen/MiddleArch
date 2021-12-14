//
//  SearchMusicRouter.swift
//  iOSArchitecturesDemo
//
//  Created by Alexander Novikov on 09.12.2021.
//  Copyright © 2021 ekireev. All rights reserved.
//

import UIKit

protocol SearchMusicRouterInput {
    func openSongInITunes(song: ITunesSong)
    func moveToAppSearch()
}

class SearchMusicRouter: SearchMusicRouterInput {
        
    func openSongInITunes(song: ITunesSong) {
        guard let urlString = song.trackUrl,
              let URL = URL(string: urlString) else { return }
        
        UIApplication.shared.open(URL, options: [:], completionHandler: nil)
    }
    
    func moveToAppSearch() {
        ScreenManager.shared.openAppSearch()
    }
}
