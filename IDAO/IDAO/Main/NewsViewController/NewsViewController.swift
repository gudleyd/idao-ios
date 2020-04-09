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

class NewsTableViewController: UITableViewController {
    
    var news: [News] = []
    var cellCached = Dictionary<Int,AnyObject>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        IdaoManager.shared.idaoStorage.setNewsTableDelegate(delegate: self)
        
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.title = "News"
        self.navigationController?.navigationBar.prefersLargeTitles = true

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "NewsCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "NewsCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        cell.setNews(news: self.news[indexPath.row]) {
            print("completionHandler")
        }
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
