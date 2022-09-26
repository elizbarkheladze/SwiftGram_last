//
//  UserNotificationsViewModel.swift
//  SwiftaGram
//
//  Created by alta on 9/15/22.
//

import UIKit


struct UserNotificationsViewModel {
    
    var notif : NotificationModel
    
    init(notif: NotificationModel) {
        self.notif = notif
    }
    
    var postImageUrl: URL? {
        return URL(string: notif.postImageUrl ?? " ")
    }
    
    var userImageUrl: URL? {
        return URL(string: notif.senderUserImageUrl)
    }
    
    var timeString: String? {
        let format = DateComponentsFormatter()
        format.allowedUnits = [.second, .minute, .hour, .day]
        format.maximumUnitCount = 1
        format.unitsStyle = .abbreviated
        return format.string(from: notif.time.dateValue(),to: Date())
    }
    
    
    var isFollowButtonHiddem : Bool { return notif.type != .followed }
    var followBtnTxt : String { return notif.currentUserIsFollowed ? "Following" : "Follow" }
    var followBtnTxtColour : UIColor { return notif.currentUserIsFollowed ? .black : .white }
    var followBtnColour : UIColor { return notif.currentUserIsFollowed ? .white : .systemBlue }
    
    var notifTxt : NSAttributedString {
        let senderUsername = notif.senderUsername
        let text = notif.type.notTxt
        
        let attedTxt = NSMutableAttributedString(string: senderUsername,attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attedTxt.append(NSAttributedString(string: text,attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        attedTxt.append(NSAttributedString(string: " \(timeString ?? " ")",attributes: [.font: UIFont.systemFont(ofSize: 12),.foregroundColor:UIColor.lightGray]))
        return attedTxt
    }
    
    var isPostHidden: Bool { return self.notif.type == .followed }
    

    
}
