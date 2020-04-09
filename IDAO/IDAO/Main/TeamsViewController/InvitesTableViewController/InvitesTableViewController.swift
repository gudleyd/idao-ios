//
//  InvitesTableViewController.swift
//  IDAO
//
//  Created by Ivan Lebedev on 09.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit

protocol InvitesTableDelegate {
    func setInvites(invites: [Int])
    func reloadTable()
}

class InvitesTableViewController: UITableViewController {
    
    var invites: [Int] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Invites"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(self.closeView))
    }
    
    @objc
    func closeView() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.invites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamInviteCell", for: indexPath)
        cell.textLabel?.text = "MyTestTeam"
        cell.detailTextLabel?.text = "leader: iplebedev"
        if #available(iOS 13.0, *) {
            cell.detailTextLabel?.textColor = .systemGray5
        } else {
            // Fallback on earlier versions
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
