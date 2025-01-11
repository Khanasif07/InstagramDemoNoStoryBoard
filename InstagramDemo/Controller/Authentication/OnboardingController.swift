//
//  OnboardingController.swift
//  InstagramDemo
//
//  Created by Asif Khan on 20/12/2024.
//

import UIKit
import FavOnboardingKit
protocol OnboardingControllerDelegate: NSObject{
    func getStartedButtonTapped(controller: UIViewController)
}
class OnboardingController: UIViewController {
    // MARK: - Properties
    private var onboardingKit: FavOnboardingKit?
    weak var delegate: OnboardingControllerDelegate?
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Helper
    func configureUI(){
        self.view.backgroundColor = .white
        DispatchQueue.main.async {
            self.onboardingKit = FavOnboardingKit(
                slides: [
                    .init(image: UIImage(named: "imSlide1")!,
                          title: "Personalised offers at 40,000+ places"),
                    .init(image: UIImage(named: "imSlide2")!,
                          title: "Stack your rewards every time you pay"),
                    .init(image: UIImage(named: "imSlide3")!,
                          title: "Enjoy now, FavePay Later"),
                    .init(image: UIImage(named: "imSlide4")!,
                          title: "Earn cashback with your physical card"),
                    .init(image: UIImage(named: "imSlide5")!,
                          title: "Save and earn cashback with Deals or eCards")
                ],
                tintColor: UIColor(red: 220/255, green: 20/255, blue: 60/255, alpha: 1.0),themeFont: UIFont(name: "Kohinoor Bangla", size: 28)!)
            self.onboardingKit?.delegate = self
            self.onboardingKit?.launchOnboarding(rootVC: self)
        }
    }
    
    //  private func transit(viewController: UIViewController) {
    //    let foregroundScenes = UIApplication.shared.connectedScenes.filter({
    //      $0.activationState == .foregroundActive
    //    })
    //
    //    let window = foregroundScenes
    //      .map({ $0 as? UIWindowScene })
    //      .compactMap({ $0 })
    //      .first?
    //      .windows
    //      .filter({ $0.isKeyWindow })
    //      .first
    //
    //    guard let uWindow = window else { return }
    //    uWindow.rootViewController = viewController
    //
    //    UIView.transition(
    //      with: uWindow,
    //      duration: 0.3,
    //      options: [.transitionCrossDissolve],
    //      animations: nil,
    //      completion: nil)
    //  }
}

// MARK: - FavOnboarfingKitDelegate
extension OnboardingController: FavOnboardingKitDelegate{
    func nextButtonDidTap(atIndex index: Int) {
        print("next button is tapped at index: \(index)")
        
    }
    
    func getStartedButtonDidTap() {
        self.dismiss(animated: true){
            self.onboardingKit?.dismissOnboarding()
            self.onboardingKit = nil
            self.delegate?.getStartedButtonTapped(controller: self)
        }
        //transit(viewController: LoginViewController())
    }
}
