//
//  TeamsTableViewController.swift
//  IDAO
//
//  Created by Ivan Lebedev on 01.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit


protocol TeamsTableDelegate: AnyObject {
    func setTeams(teams: [Team])
    func reloadTable()
}

class TeamsTableViewController: UITableViewController {
    
    var teams: [Team] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        IdaoStorage.shared.setTeamsTableDelegate(delegate: self)
        IdaoStorage.shared.getTeams { [weak self] teams in
            DispatchQueue.main.async {
                self?.teams = teams
                self?.reloadTable()
            }
        }
        
        self.title = "Teams"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addTeamButtonTapped))
        

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Invites(99)", style: .plain, target: self, action: #selector(self.openInvitesView))
        
        let nib = UINib(nibName: "TeamTableViewCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "TeamCell")
        
        self.tableView.refreshControl?.addTarget(self, action: #selector(refreshTeams), for: .valueChanged)
    }
    
    @objc
    func openInvitesView() {
        let storyboard = UIStoryboard.init(name: "InvitesView", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! UINavigationController
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc
    func refreshTeams() {
        IdaoStorage.shared.updateTeams {
            DispatchQueue(label: "refresh-waiting-\(UUID())").async {
                usleep(500000) // sleep for .5 seconds
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.refreshControl?.endRefreshing()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.teams.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as! TeamTableViewCell
        cell.setTeam(team: self.teams[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        self.tableView.deselectRow(at: indexPath, animated: false)

        self.performSegue(withIdentifier: "2TeamEditController", sender: self.teams[indexPath.row])
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        (segue.destination as! TeamEditController).team = sender as? Team
    }

}

extension TeamsTableViewController {
    
    @objc
    func addTeamButtonTapped() {
        let createTeamController = AlertViewsFactory.createTeam { [weak self] alertAction, alertController in
            let name = alertController.textFields?[0].text ?? ""
            if name == "" {
                DispatchQueue.main.async {
                    self?.present(AlertViewsFactory.emptyTeamName(), animated: true, completion: nil)
                }
            } else {
                self?.present(AlertViewsFactory.creatingTeam(), animated: true)
                IdaoManager.shared.createTeam(name: name) { [weak self] status, team in
                    DispatchQueue.main.async {
                        self?.presentedViewController?.dismiss(animated: true, completion: nil)
                    }
                    if status == .created {
                        IdaoStorage.shared.updateTeams(completionHandler: {})
                    } else if status == .teamAlreadyExists {
                        DispatchQueue.main.async {
                            self?.present(AlertViewsFactory.teamAlreadyExists(), animated: true, completion: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.present(AlertViewsFactory.unknownError(), animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        self.present(createTeamController, animated: true, completion: nil)
    }
}


extension TeamsTableViewController: TeamsTableDelegate {
    
    func setTeams(teams: [Team]) {
        DispatchQueue.main.async {
            self.teams = teams
        }
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
