//
//  UnityView.swift
//  SeptemberSwiftUI
//
//  Created by Dino Trnka on 23/09/2020.
//

import SwiftUI

struct UnityView: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
      return UnityEmbeddedSwift.getUnityView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {

    }
}

