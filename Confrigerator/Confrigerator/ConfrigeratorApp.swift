//
//  ConfrigeratorApp.swift
//  Confrigerator
//
//  Created by BAE on 5/1/24.
//

import SwiftUI
import SwiftData
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct ConfrigeratorApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn = false // 로그인 상태 관리

    init() {
        KakaoSDK.initSDK(appKey: "82336b9340bed1ec89e826f3bc1bb3b0")
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            GiftconItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                MainPage()
                    .transition(.opacity)
            } else {
                LoginPage()
                    .transition(.opacity)
                    .onOpenURL { url in
                        if (AuthApi.isKakaoTalkLoginUrl(url)) {
                            _ = AuthController.handleOpenUrl(url: url)
                        }
                    }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
