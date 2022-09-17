//
//  UserNotificationsViewModel.swift
//  SwiftaGram
//
//  Created by alta on 9/15/22.
//

import UIKit


struct UserNotificationsViewModel {
    
    private let notif : NotificationModel
    
    init(notif: NotificationModel) {
        self.notif = notif
    }
    
    var postImageUrl: URL? {
        return URL(string: notif.postImageUrl ?? " ")
    }
    
    var userImageUrl: URL? {
        return URL(string: notif.senderUserImageUrl)
    }
    
    var notifTxt : NSAttributedString {
        let senderUsername = notif.senderUsername
        let text = notif.type.notTxt
        
        let attedTxt = NSMutableAttributedString(string: senderUsername,attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attedTxt.append(NSAttributedString(string: text,attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        attedTxt.append(NSAttributedString(string: "1 hour",attributes: [.font: UIFont.systemFont(ofSize: 12),.foregroundColor:UIColor.lightGray]))
        return attedTxt
    }
}
