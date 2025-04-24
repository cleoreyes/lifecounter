//
//  HistoryViewController.swift
//  lifecounteragain
//
//  Created by Cleo Reyes on 4/23/25.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Game History"
        
        historyTableView.dataSource = self
        historyTableView.delegate = self
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameHistory.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        
        let event = GameHistory.events[GameHistory.events.count - 1 - indexPath.row]
        cell.textLabel?.text = event.message
        
        return cell
    }
}
