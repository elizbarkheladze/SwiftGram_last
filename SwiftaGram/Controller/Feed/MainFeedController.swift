//
//  MainFeedController.swift
//  SwiftaGram
//
//  Created by alta on 9/5/22.
//

import UIKit
import Firebase
import YPImagePicker

private let reuseIdentifier = "Cell"

class MainFeedController: UICollectionViewController {
    
    private var  usersPosts = [UserPost]()
    var userPost: UserPost? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var user : User?
    
    private let refresh = UIRefreshControl()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUser()
        fetchPosts()
        
        if userPost != nil {
            isPostLiked()
        }
    }
    //MARK: - API
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserService.fetchUser(uid: uid) {[weak self] user in
            self?.user = user
        }
    }
    
    func fetchPosts(){
        guard  userPost == nil else  { return }
        
        UserPostService.fetchPostsForFeed {[weak self] userPosts in
            self?.usersPosts = userPosts

            self?.isPostLiked()
            self?.collectionView.reloadData()
        }
    }
    
    func isPostLiked() {
        if let userPost = userPost {
            UserPostService.hasUserLikedPost(userPost: userPost) {[weak self] isLiked in
                self?.userPost?.didLike = isLiked
            }
        } else {
            self.usersPosts.forEach{[weak self] userPost in
                UserPostService.hasUserLikedPost(userPost: userPost) {[weak self] liked in
                    if let index = self?.usersPosts.firstIndex(where: {$0.postID  == userPost.postID}) {
                        self?.usersPosts[index].didLike = liked
                        print("KAKA : \(liked)")
                        self?.collectionView.reloadData()
                    }
                }
            }

        }
            }
    
    //MARK: - Actions
    @objc func logOutUser(){
        do {
            try Auth.auth().signOut()
            let vc = LoginController()
            vc.delegate = self.tabBarController as? TabBarController
            let navigation = UINavigationController(rootViewController: vc)
            navigation.modalPresentationStyle = .fullScreen
            self.present(navigation, animated: true,completion: nil)
        }catch{
            print("Failed to Sign out")
        }
    }
    @objc func createPost() {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.shouldSaveNewPicturesToAlbum = false
        config.startOnScreen = .library
        config.screens = [.library]
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.library.maxNumberOfItems = 1
        
        let imagepicker = YPImagePicker(configuration: config)
        imagepicker.modalPresentationStyle = .fullScreen
        present(imagepicker, animated: true, completion: nil)
        
        pickedPhoto(imagepicker)
    }
    func pickedPhoto(_ imagePicker: YPImagePicker) {
        imagePicker.didFinishPicking {[weak self] items, cancelled in
            imagePicker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                
                let vc = PostCreationController()
                vc.delegate = self
                vc.selectionImage = selectedImage
                vc.user = self?.user
                let navigation = UINavigationController(rootViewController: vc)
                navigation.modalPresentationStyle = .fullScreen
                self?.present(navigation, animated: false, completion: nil)
            }
        }
    }
    @objc func refreshAction(){
        usersPosts.removeAll()
        fetchPosts()
        collectionView.refreshControl?.endRefreshing()
    }
    
    // MARK: - Helpers
    func configureUI() {
        refresh.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        collectionView.refreshControl = refresh
        collectionView.backgroundColor = .black
        collectionView.register(MainFeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        if userPost == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain,
                                                               target: self, action: #selector(logOutUser))
            navigationItem.leftBarButtonItem?.tintColor = .white
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus_unselected")?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(createPost))
        }

        navigationItem.title = "Feed"
        navigationController?.navigationBar.barTintColor = UIColor.black
    }
}

// MARK: - UIcollectionViewDataSource

extension MainFeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPost == nil ? usersPosts.count : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainFeedCell
        cell.delegate = self
        if let userPost = userPost {
            cell.viewModel = UersPostViewModel(userpost: userPost)
        }else {
            cell.viewModel = UersPostViewModel(userpost: usersPosts[indexPath.row])
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainFeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 110
        return CGSize(width:width,height:height)
    }
}

extension MainFeedController : MainFeedCellDelegate {
    func profileTapped(_ cell: MainFeedCell, uid: String) {
        UserService.fetchUser(uid: uid) {[weak self] user in
            let vc = UserProfileController(user: user)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func postLikeTapped(_ cell: MainFeedCell, userPost: UserPost) {
        guard let tabBarCont = self.tabBarController as? TabBarController else {return}
        guard let user = tabBarCont.user else {return}
        cell.viewModel?.userpost.didLike.toggle()
        if userPost.didLike {
            UserPostService.postUnliked(userPost: userPost) { error in
                cell.likeBtn.setImage(UIImage(imageLiteralResourceName: "like_unselected"), for: .normal)
                cell.likeBtn.tintColor = .black
                cell.viewModel?.userpost.like = userPost.like - 1
            }
            
        }else {
            UserPostService.postLiked(userPost: userPost) { error in
                cell.likeBtn.setImage(UIImage(imageLiteralResourceName: "like_selected"), for: .normal)
                cell.likeBtn.tintColor = .red
                cell.viewModel?.userpost.like = userPost.like + 1
                
                UserNotificationsService.sendUserNotification(uid: userPost.publisherID,user: user, type: .liked, userPost: userPost)
            }
        }
    }
    
    func tappedCommentsOnCell(_ cell: MainFeedCell, userPost: UserPost) {
        let vc = CommentsController(userPost: userPost)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension MainFeedController: PostCreationControllerDelegate {
    func userPublishedPost(_ controller: PostCreationController) {
        controller.dismiss(animated: true, completion: nil)
        refreshAction()
    }
}

