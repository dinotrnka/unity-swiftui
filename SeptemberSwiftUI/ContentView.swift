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
    VStack {
      NavigationLink(
        destination: UnityView(),
        isActive: $linkActive
      ) { }
      Button(action: {
        UnityEmbeddedSwift.showUnity()
        linkActive = true
      }) {
        Text("Open Unity")
          .background(Color.pink)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
