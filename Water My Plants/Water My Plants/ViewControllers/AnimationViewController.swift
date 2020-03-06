//
//  AnimationViewController.swift
//  Water My Plants
//
//  Created by Sal B Amer on 3/6/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Lottie

class AnimationViewController: UIViewController {

    @IBOutlet private var animationView: AnimationView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playAnimation()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
        
            //segue 8 seconds later
//        let vc = UIViewController()
//        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
//            elf.present(vc, animated: true, completion: nil)
        if let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewSegue") as? LoginViewController {
                self.present(secondViewController, animated: true, completion: nil)
            }
        }
    }
    
    func playAnimation() {
        animationView.animation = Animation.named("grow")
        animationView.loopMode = .loop
        animationView.play()
    }

}
