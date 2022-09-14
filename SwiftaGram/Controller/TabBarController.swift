//
//  TabBarController.swift
//  SwiftaGram
//
//  Created by alta on 9/5/22.
//

import UIKit
import Firebase
import YPImagePicker
import AVFoundation

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
        UserService.fetchUser(uid: uid) { user in
            self.user = user
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
        self.delegate = self
        view.backgroundColor = .white
        
        let feedLayout = UICollectionViewFlowLayout()
        let feed = navigationControlloerTemplate(selectedImage: UIImage(imageLiteralResourceName: "home_selected"), notSelectedImage: UIImage(imageLiteralResourceName: "home_unselected"), vc: MainFeedController(collectionViewLayout : feedLayout))
        
        let search = navigationControlloerTemplate(selectedImage: UIImage(imageLiteralResourceName: "search_selected"), notSelectedImage: UIImage(imageLiteralResourceName: "search_unselected"), vc: SearchController())
        
        let post = navigationControlloerTemplate(selectedImage: UIImage(imageLiteralResourceName: "plus_unselected"), notSelectedImage: UIImage(imageLiteralResourceName: "plus_unselected"), vc: PostController())
        
        let nofitications = navigationControlloerTemplate(selectedImage: UIImage(imageLiteralResourceName: "like_selected"), notSelectedImage: UIImage(imageLiteralResourceName: "like_unselected"), vc: NotificationsController())
        
        
        let userProfileVC = UserProfileController(user: user)
        let userProfile = navigationControlloerTemplate(selectedImage: UIImage(imageLiteralResourceName: "profile_selected"), notSelectedImage: UIImage(imageLiteralResourceName: "profile_unselected"), vc: userProfileVC)
        
        viewControllers = [feed, search, post , nofitications, userProfile]
        
        tabBar.tintColor = .black
    }
    
    
    func pickedPhoto(_ imagePicker: YPImagePicker) {
        imagePicker.didFinishPicking { items, cancelled in
            imagePicker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                
                let vc = PostCreationController()
                vc.delegate = self
                vc.selectionImage = selectedImage
                vc.user = self.user
                let navigation = UINavigationController(rootViewController: vc)
                navigation.modalPresentationStyle = .fullScreen
                self.present(navigation, animated: false, completion: nil)
            }
        }
    }
    
    func navigationControlloerTemplate(selectedImage: UIImage, notSelectedImage: UIImage, vc: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: vc)
        navigation.tabBarItem.image = notSelectedImage
        navigation.tabBarItem.selectedImage = selectedImage
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

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            print("KAKA 98934")
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
        return true
    }
}

extension TabBarController: PostCreationControllerDelegate {
    func userPublishedPost(_ controller: PostCreationController) {
        selectedIndex = 0
        controller.dismiss(animated: true, completion: nil)
        
        guard let mainFeedNavigation = viewControllers?.first as? UINavigationController else { return }
        guard let mainFeed = mainFeedNavigation.viewControllers.first as? MainFeedController else { return }
        mainFeed.refresh()
    }
}
