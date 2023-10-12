//
//  ContentView.swift
//  PZImage
//
//  Created by David Harkey on 10/12/23.
//

import SwiftUI

struct ContentView: View {
    let images: [ImageResource] = [.bg1, .bg2, .bg2, .bg4, .bg5]
    
    var body: some View {
        VStack {
            PZImage(
                images,
                imageOpacity: 0.8,
                changeImageTime: 10.0
            )
                .overlay(alignment: .bottomTrailing) {
                    VStack(alignment: .trailing) {
                        Text("Welcome to")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .shadow(color: .black, radius: 3, x: 0, y: 0)
                            .padding(.horizontal)
                        
                        Text("New York")
                            .font(.largeTitle)
                            .fontWidth(.expanded)
                            .fontWeight(.heavy)
                            .shadow(color: .black, radius: 10, x: 0, y: 0)
                            .padding([.horizontal, .bottom])
                    }
                }
            
            Spacer()
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
