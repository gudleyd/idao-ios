//
//  TeamsTableViewController.swift
//  IDAO
//
//  Created by Ivan Lebedev on 01.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit


class TeamsTableViewController: UITableViewController {
    
    var teams: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        IdaoStorage.teams.subscribe(TeamsStorage.StorageObserver(delegate: self))
        IdaoStorage.invites.subscribe(InvitesStorage.StorageObserver(delegate: self))
        
        IdaoStorage.teams.get { [weak self] teams in
            DispatchQueue.main.async {
                print(teams)
                self?.teams = teams
                self?.tableView.reloadData()
            }
        }
        
        IdaoStorage.invites.get { [weak self] invites in
            DispatchQueue.main.async {
                self?.navigationItem.leftBarButtonItem?.title = "Invites(\(invites.count))"
            }
        }
        
        self.title = "Teams"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addTeamButtonTapped))
        

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Invites(--)", style: .plain, target: self, action: #selector(self.openInvitesView))
        
        let nib = UINib(nibName: "TeamTableViewCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "TeamCell")
        
        self.tableView.refreshControl?.addTarget(self, action: #selector(refreshTeams), for: .valueChanged)
        
        let teamTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(teamTapped))
        self.view.addGestureRecognizer(teamTapGestureRecognizer)
    }
    
    @objc
    func teamTapped(teamTappedGestureRecognizer: UITapGestureRecognizer) {

        if teamTappedGestureRecognizer.state == UIGestureRecognizer.State.ended {
            let touchPoint = teamTappedGestureRecognizer.location(in: self.view)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                self.present(TeamActionSheet(teamId: self.teams[indexPath.row], parentView: self), animated: true, completion: nil)
            }
        }
    }
    
    @objc
    func openInvitesView() {
        let storyboard = UIStoryboard.init(name: "InvitesView", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! UINavigationController
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc
    func refreshTeams() {
        IdaoStorage.teams.update(forceUpdate: true) {
            IdaoStorage.invites.update(forceUpdate: true) {
                DispatchQueue(label: "refresh-waiting-\(UUID())").async {
                    usleep(500000) // sleep for .5 seconds
                    DispatchQueue.main.async { [weak self] in
                        self?.tableView.refreshControl?.endRefreshing()
                    }
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
        cell.setTeam(teamId: self.teams[indexPath.row])
        cell.layoutIfNeeded()
        cell.delegate = self
        return cell
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
                DispatchQueue.main.async {
                    self?.present(AlertViewsFactory.creatingTeam(), animated: true)
                    IdaoManager.shared.createTeam(name: name) { [weak self] status, team in
                        DispatchQueue.main.async {
                            self?.presentedViewController?.dismiss(animated: true) { [weak self] in
                                if status == .created {
                                    IdaoStorage.teams.update { }
                                } else if status == .teamAlreadyExists {
                                    self?.present(AlertViewsFactory.teamAlreadyExists(), animated: true, completion: nil)
                                } else {
                                    self?.present(AlertViewsFactory.unknownError(), animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
            }
        }
        self.present(createTeamController, animated: true, completion: nil)
    }
}


extension TeamsTableViewController: StorageObserverDelegate {
    func update(_ sender: Any?, _ data: Any?) {
        if (sender as? TeamsStorage) != nil {
            DispatchQueue.main.async { [weak self] in
                guard let teams = data as? [Int] else { return }
                self?.teams = teams
                self?.tableView.reloadData()
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let invites = data as? [Int] else { return }
                self?.navigationItem.leftBarButtonItem?.title = "Invites(\(invites.count))"
            }
        }
    }
}

extension TeamsTableViewController: AutomaticHeightCellDelegate {
    func contentDidChange() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
