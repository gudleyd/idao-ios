//
//  NewsViewController.swift
//  IDAO
//
//  Created by Ivan Lebedev on 30.03.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit

protocol AutomaticHeightCellDelegate: AnyObject {
    func contentDidChange(height: CGFloat?, at: IndexPath?)
}

class NewsTableViewController: UITableViewController {
    
    var news: [News] = []
    var heights: [IndexPath: CGFloat] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "News"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.tableView.refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)

        let nib = UINib(nibName: "NewsCell", bundle: .main)
        self.tableView.register(nib, forCellReuseIdentifier: "NewsCell")
        
        IdaoStorage.news.subscribe(NewsStorage.StorageObserver(delegate: self))
        IdaoStorage.news.update { }
    }
    
    @objc
    func refreshNews() {
        IdaoStorage.news.update(forceUpdate: true) { }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.setNews(news: self.news[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? NewsCell else { return }
        cell.cancelRendering()
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heights[indexPath] ?? UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heights[indexPath] ?? UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        self.tableView.deselectRow(at: indexPath, animated: false)

        self.performSegue(withIdentifier: "DetailNews", sender: self.news[indexPath.row])
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? DetailNewsViewController)?.news = sender as? News
    }

}

extension NewsTableViewController: StorageObserverDelegate {
    func update(_ sender: Any?, _ data: Any?) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
            guard let news = data as? [News] else { return }
            self?.news = news
            self?.tableView.reloadData()
        }
    }
}

extension NewsTableViewController: AutomaticHeightCellDelegate {
    func contentDidChange(height: CGFloat?, at: IndexPath?) {
        guard let height = height else { return }
        guard let at = at else { return }
        self.heights[at] = height
        UIView.performWithoutAnimation {
            self.tableView.performBatchUpdates(nil, completion: nil)
        }
    }
}
