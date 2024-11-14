//
//  MainPage.swift
//  Confrigerator
//
//  Created by BAE on 5/1/24.
//

import SwiftUI

struct MainPage: View {
    
    init() {
        setupTabBarAppearance()
    }

    var body: some View {
        ZStack {
            TabView {
                ConfrigeratorTab()
                    .tabItem {
                        Label("콘장고", systemImage: "barcode")
                    }
                AddConTab() // 뷰 모델을 전달
                    .tabItem {
                        Label("콘 등록하기", systemImage: "plus.app")
                    }
                MyPageTab()
                    .tabItem {
                        Label("마이페이지", systemImage: "person.fill")
                    }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // 선택된 항목의 색상
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.black
        
        // 선택되지 않은 항목의 색상
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.lightGray]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.lightGray
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
        
}

