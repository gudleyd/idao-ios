//
//  NewsViewController.swift
//  IDAO
//
//  Created by Ivan Lebedev on 30.03.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit
import MarkdownView

protocol NewsTableDelegate: AnyObject {
    func setNews(news: [News])
    func reloadTable()
}

protocol AutomaticHeightCellDelegate: AnyObject {
    func contentDidChange()
}

class NewsTableViewController: UITableViewController {
    
    var news: [News] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        IdaoStorage.shared.setNewsTableDelegate(delegate: self)
        
        self.title = "News"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension

        let nib = UINib(nibName: "NewsCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "NewsCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        cell.setNews(news: self.news[indexPath.row]) {
            print("completionHandler")
        }
        cell.automaticHeightTV = self
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewsTableViewController: AutomaticHeightCellDelegate {
    func contentDidChange() {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}


extension NewsTableViewController: NewsTableDelegate {
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setNews(news: [News]) {
        DispatchQueue.main.async {
            self.news = news
            print(news)
        }
    }
}
