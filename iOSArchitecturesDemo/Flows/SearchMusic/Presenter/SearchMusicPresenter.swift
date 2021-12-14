//
//  SearchMusicPresenter.swift
//  iOSArchitecturesDemo
//
//  Created by Alexander Novikov on 09.12.2021.
//  Copyright © 2021 ekireev. All rights reserved.
//

import UIKit
import Alamofire

protocol SearchMusicViewInput: class {
    var searchResults: [ITunesSong] { get set }
    func showError(error: Error)
    func hideNoResults()
    func showNoResults()
    func throbber(show: Bool)
}

protocol SearchMusicViewOutput {
    func viewDidSearch(with query: String)
    func viewDidSelectSong(_ song: ITunesSong)
    func viewDidMoveToAppSearch()
}

class SearchMusicPresenter {
    let interactor: SearchMusicInteractorInput
    let router: SearchMusicRouterInput
    
    weak var viewInput: (UIViewController & SearchMusicViewInput)?
    
    init(interactor: SearchMusicInteractorInput, router: SearchMusicRouterInput) {
        self.interactor = interactor
        self.router = router
    }
    
    private func requestMusic(with query: String) {
        interactor.requestSongs(with: query) { [weak self] (result) in
            guard let self = self else { return }
            
            self.viewInput?.throbber(show: false)
            result.withValue { (songs) in
                guard !songs.isEmpty else {
                    self.viewInput?.showNoResults()
                    return
                }
                self.viewInput?.hideNoResults()
                self.viewInput?.searchResults = songs
            }
            .withError { (error) in
                self.viewInput?.showError(error: error)
            }
        }
    }
    
    private func openSongDetail(with song: ITunesSong) {
        router.openSongInITunes(song: song)
    }
}

extension SearchMusicPresenter: SearchMusicViewOutput {
    func viewDidSearch(with query: String) {
        self.viewInput?.throbber(show: true)
        requestMusic(with: query)
    }
    
    func viewDidSelectSong(_ song: ITunesSong) {
        openSongDetail(with: song)
    }
    
    func viewDidMoveToAppSearch() {
        router.moveToAppSearch()
    }
}

