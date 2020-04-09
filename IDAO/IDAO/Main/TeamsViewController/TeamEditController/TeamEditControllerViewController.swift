//
//  TeamEditControllerViewController.swift
//  IDAO
//
//  Created by Ivan Lebedev on 05.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit

class TeamEditController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addMemberButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var team: Team?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.addMemberButton.layer.cornerRadius = 8
        self.tableView.layer.cornerRadius = 8
        self.tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameLabel.text = team?.name
        if #available(iOS 13.0, *) {
            self.navigationController?.navigationBar.setNeedsLayout()
        }
    }

    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.team?.teamMembers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.tableView.beginUpdates()
            self.team?.teamMembers?.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamMemberCell", for: indexPath)
        cell.textLabel?.text = self.team?.teamMembers?[indexPath.row].name
        cell.detailTextLabel?.text = self.team?.teamMembers?[indexPath.row].username
        cell.backgroundColor = .clear
        if self.team?.teamMembers?[indexPath.row].isLeader() ?? false {
            let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
            label.text = "Leader"
            label.textColor = .systemGreen
            cell.accessoryView = label
        }

        return cell
    }

}
