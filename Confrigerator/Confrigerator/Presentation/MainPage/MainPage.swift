//
//  MainPage.swift
//  Confrigerator
//
//  Created by BAE on 5/1/24.
//

import SwiftUI

struct MainPage: View {
    private let images = Array(repeating: "photo", count: 6)
    
    var body: some View {
        ZStack {
            TabView {
                ConfrigeratorTab()
                    .tabItem {
                        Label("콘장고", systemImage: "star.fill")
                    }
                AddConTab()
                    .tabItem {
                        Label("콘 등록하기", systemImage: "star.fill")
                    }
                MyPageTab()
                    .tabItem {
                        Label("마이페이지", systemImage: "star.fill")
                    }
                
            }
        }
        .navigationBarBackButtonHidden()
    }
        
}


#Preview {
    MainPage()
}
