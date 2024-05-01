//
//  MainPage.swift
//  Confrigerator
//
//  Created by BAE on 5/1/24.
//

import SwiftUI

struct MainPage: View {
    private let images = Array(repeating: "photo", count: 6)
    @StateObject var viewModel = MainPageViewModel()
    
    var body: some View {
        ZStack {
            TabView {
                ConfrigeratorTab(dummy: viewModel.dummyViewModelData)
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
