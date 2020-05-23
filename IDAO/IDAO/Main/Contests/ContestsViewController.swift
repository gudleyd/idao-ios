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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IdaoStorage.contests.get { [weak self] contests in
            print(contests)
            DispatchQueue.main.async {
                self?.contests = contests
                self?.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        IdaoStorage.contests.subscribe(ContestsStorage.StorageObserver(delegate: self))

        self.title = "Contests"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let nib = UINib(nibName: "ContestCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "ContestCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.contests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContestCell", for: indexPath) as! ContestCell
        cell.delegate = self
        cell.setContest(contest: self.contests[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: false)
        
        self.performSegue(withIdentifier: "DetailContest", sender: self.contests[indexPath.row])
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
            guard let contests = data as? [Contest] else { return }
            self?.contests = contests
            self?.tableView.reloadData()
        }
    }
}

extension ContestsViewController: AutomaticHeightCellDelegate {
    func contentDidChange() {
        UIView.animate(withDuration: 0) {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
}
