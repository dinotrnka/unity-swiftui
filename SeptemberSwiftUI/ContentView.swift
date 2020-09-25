//
//  ContentView.swift
//  SeptemberSwiftUI
//
//  Created by Dino Trnka on 23/09/2020.
//

import SwiftUI

struct ContentView: View {
  @State var linkActive = false

  var body: some View {
    Button(action: {
      UnityEmbeddedSwift.showUnity()
    }) {
      Text("Open Unity My Friend")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
