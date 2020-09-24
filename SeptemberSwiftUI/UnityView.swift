//
//  UnityView.swift
//  SeptemberSwiftUI
//
//  Created by Dino Trnka on 23/09/2020.
//

import SwiftUI

struct UnityView: UIViewControllerRepresentable {

  func makeUIViewController(context: Context) -> UIViewController {
    return UnityEmbeddedSwift.getUnityRootview()
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {

  }
}
