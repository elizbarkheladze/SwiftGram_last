//
//  TabBarController.swift
//  SwiftaGram
//
//  Created by alta on 9/5/22.
//

import UIKit
import Firebase
import YPImagePicker

class TabBarController: UITabBarController {
    
     var user : User? {
        didSet{
            guard let user = user else { return }
            vCConfiguration(user: user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - Lifecycle
        isUserLoggedIn()
        fetchUser()

    }
    
    
    //MARK: - API
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserService.fetchUser(uid: uid) {[weak self] user in
            self?.user = user
        }
    }
    
    func isUserLoggedIn(){
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let vc = LoginController()
                vc.delegate = self
                let navigation = UINavigationController(rootViewController: vc)
                navigation.modalPresentationStyle = .fullScreen
                self.present(navigation, animated: true,completion: nil)
            }
        }
    }
    

    
    // MARK: - Helpers
    
    func vCConfiguration(user: User) {
        view.backgroundColor = .white
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .black
        
        
        let feedLayout = UICollectionViewFlowLayout()
        let feed = navigationControlloerTemplate(selectedImage: UIImage(imageLiteralResourceName:  "home_selected"), notSelectedImage: UIImage(imageLiteralResourceName: "home_unselected"), vc: MainFeedController(collectionViewLayout : feedLayout))
        
        let search = navigationControlloerTemplate(selectedImage: UIImage(imageLiteralResourceName: "search_selected"), notSelectedImage: UIImage(imageLiteralResourceName: "search_unselected"), vc: SearchController())
        
        let nofitications = navigationControlloerTemplate(selectedImage: UIImage(imageLiteralResourceName: "like_selected"), notSelectedImage: UIImage(imageLiteralResourceName: "like_unselected"), vc: NotificationsController())
        
        
        let userProfileVC = UserProfileController(user: user)
        let userProfile = navigationControlloerTemplate(selectedImage: UIImage(imageLiteralResourceName: "profile_selected"), notSelectedImage: UIImage(imageLiteralResourceName: "profile_unselected"), vc: userProfileVC)
        
        viewControllers = [feed, search, nofitications, userProfile]
        
        tabBar.tintColor = .black
    }
    

    func navigationControlloerTemplate(selectedImage: UIImage, notSelectedImage: UIImage, vc: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: vc)
        navigation.tabBarItem.image = notSelectedImage.withTintColor(.white, renderingMode: .alwaysOriginal)
        navigation.tabBarItem.selectedImage = selectedImage.withTintColor(.white, renderingMode: .alwaysOriginal)
        navigation.tabBarItem.badgeColor = .white
        navigation.navigationBar.tintColor = .black
        
        return navigation
    }
}

extension TabBarController : AuthDelegate {
    func authWasComplete() {
        fetchUser()
        self.dismiss(animated: true,completion: nil)
    }
}
