//
//  ViewController.swift
//  SeptemberSwiftUI
//
//  Created by Dino Trnka on 25/09/2020.
//

import UIKit
import SwiftUI
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let vc = UIHostingController(rootView: ContentView())
        addChild(vc)
        vc.view.frame = self.view.frame
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
//        present(UnityEmbeddedSwift.getController(), animated: true, completion: nil)
    }


}

