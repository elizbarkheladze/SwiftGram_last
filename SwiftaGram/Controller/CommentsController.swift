//
//  CommentsController.swift
//  SwiftaGram
//
//  Created by alta on 9/14/22.
//

import UIKit
private let identifier = "CommentsCell"
class CommentsController: UICollectionViewController {
    
    private let userPost: UserPost
    private var userComments = [UserCommentModel]()
    
    
    private lazy var commentCreationView:CommentInputView = {
        let view = CommentInputView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        view.delegate = self
        return view
    }()
    
    init(userPost: UserPost) {
        self.userPost = userPost
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override var inputAccessoryView: UIView?{
        get {
            return commentCreationView
        }
    }
    
    func configureUI() {
        collectionView.register(CommentsCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.backgroundColor = .white
        collectionView.keyboardDismissMode = .interactive
        collectionView.alwaysBounceVertical = true 
    }
    
    func fetchComments() {
        UserCommentsService.fetchComments(postID: userPost.postID) { userComments in
            self.userComments = userComments
            self.collectionView.reloadData()
        }
    }
}




//MARK: - FlowDelegate $ DataSource
extension CommentsController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userComments.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CommentsCell
        cell.viewModel = UserCommentsViewModel(userComment: userComments[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = UserCommentsViewModel(userComment: userComments[indexPath.row])
        let height = viewModel.cellSize(width: view.frame.width).height + 34
        
        return CGSize(width: view.frame.width, height: height)
    }
}

extension CommentsController : CommentInputViewDelegate {
    func commentInputView(_ commentInputView: CommentInputView, uploadComment: String) {
       
        
        guard let tabBarCont = self.tabBarController as? TabBarController else {return}
        guard let user = tabBarCont.user else {return}
        
        UserCommentsService.publishComment(commentText: uploadComment, userPostID: userPost.postID, user: user) { error in
            commentInputView.deleteCommentTxt()
        }
    }
}

extension CommentsController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let uid = userComments[indexPath.row].uid
        UserService.fetchUser(uid: uid) { user in
            let vc = UserProfileController(user: user)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
