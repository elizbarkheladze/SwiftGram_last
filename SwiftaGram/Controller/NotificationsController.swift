//
//  NotificationsController.swift
//  SwiftaGram
//
//  Created by alta on 9/5/22.
//

import UIKit
private let identifier = "NotCell"

class NotificationsController: UITableViewController {
    
    private var notifications = [NotificationModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotifications()
        configureUI()
    }
    
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title  = "NOTIFICATIONS"
        
        tableView.register(NotCell.self, forCellReuseIdentifier: identifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
    
    func fetchNotifications() {
        UserNotificationsService.fetchUserNotifications { notifs in
            self.notifications = notifs
        }
    }
}

extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! NotCell
        cell.viewModel = UserNotificationsViewModel(notif: notifications[indexPath.row])
        return cell
    }
}
