//
//  NewsViewController.swift
//  IDAO
//
//  Created by Ivan Lebedev on 30.03.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit

protocol AutomaticHeightCellDelegate: AnyObject {
    func contentDidChange()
}

class NewsTableViewController: UITableViewController {
    
    var news: [News] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "News"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.tableView.refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)

        let nib = UINib(nibName: "NewsCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "NewsCell")
        
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
        cell.setNews(news: self.news[indexPath.row])
        return cell
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
    func contentDidChange() {
        UIView.animate(withDuration: 0) {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
}
