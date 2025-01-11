//
//  MainTabController.swift
//  InstagramDemo
//
//  Created by Asif Khan on 12/12/2024.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import YPImagePicker
class MainTabController: UITabBarController{
    // MARK: - Properties
    var user: User?{
        didSet{
            configureViewControllers(withUser: user!)
        }
    }
    
    // MARK: - View life cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        checkIfUserLoggedIn()
        fetchUser()
    }
    
    // MARK: - API
    private func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fetchUser(withUid: uid) { user in
            print("Debug: user model \(user)")
            self.user = user
        }
    }
    
    private func checkIfUserLoggedIn(){
        if Auth.auth().currentUser == nil{
            DispatchQueue.main.async {
                //                let controller = LoginViewController()
                //                controller.delegate = self
                //                let nav = UINavigationController(rootViewController: controller)
                //                nav.modalPresentationStyle = .fullScreen
                //                self.present(nav, animated: true)
                //
                let controller = OnboardingController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
                
            }
        }
    }

    //Configure viewcontrollers
    func configureViewControllers(withUser user: User){
        self.delegate = self
        let profileController = ProfileController(user: user)
        let feedVC = templateNavigationController(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootViewController: FeedController())
        let searchVC = templateNavigationController(unselectedImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!, rootViewController: SearchController())
        let profileVC = templateNavigationController(unselectedImage: UIImage(named: "profile_unselected")!, selectedImage: UIImage(named: "profile_selected")!, rootViewController: profileController)
        let notificationVC = templateNavigationController(unselectedImage: UIImage(named: "like_unselected")!, selectedImage: UIImage(named: "like_selected")!, rootViewController: NotificationController())
        let imageSelectorVC = templateNavigationController(unselectedImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!, rootViewController: ImageSelectorController())
        
        viewControllers = [feedVC,searchVC,imageSelectorVC,notificationVC,profileVC]
    }
    
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController{
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
    
    func didFinishPickingMedia(_ aPicker: YPImagePicker){
        aPicker.didFinishPicking { items, cancelled in
            aPicker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else { return}
                let controller = UploadPostController()
                controller.currentUser = self.user
                controller.delegate = self
                controller.selectedImage = selectedImage
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false)
                
            }
        }
        
    }
}

// MARK: - AuthenticationDelegate
extension MainTabController: AuthenticationDelegate{
    func authenticationDidComplete() {
        fetchUser()
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK: - AuthenticationDelegate
extension MainTabController: OnboardingControllerDelegate{
    func getStartedButtonTapped(controller: UIViewController) {
           controller.dismiss(animated: false)
            print("Navigation controller dismissed.")
            let controller = LoginViewController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
    }
    
}

// MARK: - UITabBarControllerDelegate
extension MainTabController: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2{
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            let picker  = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true)
            
            didFinishPickingMedia(picker)
        }
        return true
    }
}

// MARK: - UploadPostControllerDelegate
extension MainTabController: UploadPostControllerDelegate{
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        self.selectedIndex = 0
        controller.dismiss(animated: true)
        
        guard let feedNav = viewControllers?.first as? UINavigationController else { return }
        guard let profileNav = viewControllers?.last as? UINavigationController else { return }
        guard let feed = feedNav.viewControllers.first as? FeedController else { return}
        guard let profile = profileNav.viewControllers.last as? ProfileController else { return}
        feed.handleRefresh()
        profile.hitApi()
    }
}
