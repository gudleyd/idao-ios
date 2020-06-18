//
//  ContestsViewController.swift
//  IDAO
//
//  Created by Ivan Lebedev on 24.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit

class ContestsViewController: UITableViewController {
    
    var contests: [Contest] = []
    var heights: [IndexPath: CGFloat] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Contests"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.tableView.refreshControl?.addTarget(self, action: #selector(refreshContests), for: .valueChanged)
        
        let nib = UINib(nibName: "ContestCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "ContestCell")
        
        IdaoStorage.contests.subscribe(ContestsStorage.StorageObserver(delegate: self))
        IdaoStorage.contests.update { }
    }
    
    @objc
    func refreshContests() {
        IdaoStorage.contests.update(forceUpdate: true) { }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContestCell", for: indexPath) as! ContestCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.setContest(contest: self.contests[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heights[indexPath] ?? UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heights[indexPath] ?? UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: false)
        
        self.performSegue(withIdentifier: "DetailContest", sender: self.contests[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ContestCell else { return }
        cell.cancelRendering()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? DetailContestViewController)?.contest = sender as? Contest
    }

}

extension ContestsViewController: StorageObserverDelegate {
    func update(_ sender: Any?, _ data: Any?) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
            guard let contests = data as? [Contest] else { return }
            self?.contests = contests
            self?.tableView.reloadData()
        }
    }
}

extension ContestsViewController: AutomaticHeightCellDelegate {
    func contentDidChange(height: CGFloat?, at: IndexPath?) {
        guard let height = height else { return }
        guard let at = at else { return }
        self.heights[at] = height
        UIView.performWithoutAnimation {
            self.tableView.performBatchUpdates(nil, completion: nil)
        }
    }
}
