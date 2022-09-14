//
//  UserProfileController.swift
//  SwiftaGram
//
//  Created by alta on 9/5/22.
//

import UIKit

private let UserProfilecellReusableIdentifier = "UserCell"
private let headerCellReusableIdentifier = "Userheader"

class UserProfileController: UICollectionViewController {
    
    //MARK: - Properties
    private var userPosts = [UserPost]()
    private var user: User
    //MARK: - LIfeCycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfiguration()
        isprofileFollowed()
        fetchStatsofUser()
        fetchUSerPosts()
        
    }
    
    //MARK: - API

    func isprofileFollowed() {
        UserService.isUserFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchStatsofUser() {
        UserService.fetchStatsofUser(uid: user.uid) { stat in
            self.user.stat = stat
            self.collectionView.reloadData()
        }
    }
    
    func fetchUSerPosts() {
        UserPostService.fetchPostsForProfile(uid: user.uid) { posts in
            self.userPosts = posts
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - Helpers
    
    func uiConfiguration(){
        navigationItem.title = user.username
        collectionView.backgroundColor = .white
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserProfilecellReusableIdentifier)
        collectionView.register(Userheader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellReusableIdentifier)
        navigationItem.title = "\(user.username)"
    }
}
//MARK: - DataSource _ Delegate
extension UserProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userPosts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfilecellReusableIdentifier, for: indexPath) as! UserCell
        cell.viewModel = UersPostViewModel(userpost: userPosts[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellReusableIdentifier, for: indexPath) as! Userheader
        header.delegate = self
            header.viewModel = UserHeaderViewmodel(user: user)
          
        return header
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension UserProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 2) / 3
        return CGSize(width:width,height:width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
}

//MARK: - UserHeaderDelegate
extension UserProfileController : UserHeaderDelegate {
    func header(_ userHeader: Userheader, didTap user: User) {
        
        if user.isLoggedInUser{
            
        } else if user.isFollowed {
            UserService.unFollowUser(uid: user.uid) { error in
                self.user.isFollowed = false
                self.collectionView.reloadData()
                print("KAKA: did unwollow \(user.name)")
            }
        }else {
            UserService.followUser(uid: user.uid) { error in
                self.user.isFollowed = true
                self.collectionView.reloadData()
                print("KAKA: did wolow \(user.name)")
            }
        }
    }
}

extension UserProfileController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MainFeedController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.userPost = userPosts[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
