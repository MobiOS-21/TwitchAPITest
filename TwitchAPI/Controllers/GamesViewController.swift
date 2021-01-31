//
//  GamesViewController.swift
//  TwitchAPI
//
//  Created by Александр Дергилёв on 30.01.2021.
//

import UIKit
import Kingfisher

class GamesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var refreshControl: UIRefreshControl!
    
    var games: [Game] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Top Games"
        tableView.delegate = self
        tableView.dataSource = self

        refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        refreshControl.addTarget(self, action: #selector(reloadData(with:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        reloadData(with: false)
    }

    override func viewWillLayoutSubviews() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc
    func reloadData(with pagination: Bool = false) {
        GameDataService.instance.downloadTopGames(limit: 10, with: pagination)
        GameDataService.instance.completionHandler { [weak self] (games, status, message) in
            guard let sself = self else { return }
            if status, let games = games {
                pagination == false ? sself.games = games : sself.games.append(contentsOf: games)
                sself.tableView.reloadData()
                sself.tableView.tableFooterView = nil
                sself.loadingIndicator.stopAnimating()
                sself.refreshControl.endRefreshing()
            }
        }
    }
    
    private func setupFooterIndicator() -> UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        spinner.color = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    //MARK:- TableVeiwDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameCell else {
            return UITableViewCell()
        }
        let game = games[indexPath.row]
        cell.gameNameLb.text = game.name
        cell.channelsLb.text = "Channels: \(String(game.channels ?? 0))"
        cell.viewersLb.text = "Viewers: \(String(game.viewers ?? 0))"
        cell.gameLogoIV.kf.indicatorType = .activity
        cell.gameLogoIV.kf.setImage(with: URL(string: game.logoUrl!))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        if !GameDataService.instance.loadNextGames && (contentHeight - contentOffsetY + 100 < frameHeight) {
            reloadData(with: true)
            tableView.tableFooterView = setupFooterIndicator()
        }
    }
}
