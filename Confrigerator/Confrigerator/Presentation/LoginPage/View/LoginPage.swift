//
//  LoginPage.swift
//  Confrigerator
//
//  Created by BAE on 5/1/24.
//

import SwiftUI
import SwiftData
import KakaoSDKAuth
import KakaoSDKUser

struct LoginPage: View {
    @State private var username: String = ""
    @State private var password: String = ""
    // NavigationLink의 활성화를 제어하기 위한 상태 변수
    @State private var shouldShowMainPage = false
    @State private var tag: Int? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                // 로고
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(50)
                
                Spacer()
                
                KakaoSigninButton(present: $shouldShowMainPage)
            }
            .padding()
            .navigationDestination(isPresented: self.$shouldShowMainPage) {
                MainPage()
            }
        }
    }
}

#Preview {
    LoginPage()
        .modelContainer(for: GiftconItem.self, inMemory: true)
}


struct KakaoSigninButton: View {
    @Binding var present: Bool
    @AppStorage("userNickname") private var userNickname: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some View {
        Button {
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    } else {
                        print("loginWithKakaoTalk() success.")
                        self.present.toggle()
                        // 성공 시 동작 구현
                        _ = oauthToken
                        withAnimation {
                            isLoggedIn = true
                        }
                        UserApi.shared.me { (user, erroe) in
                            if let error = error {
                                print(error)
                            } else {
                                userNickname = user?.kakaoAccount?.profile?.nickname ?? "닉네임을 불러올 수 없습니다."
                            }
                        }
                    }
                }
            }
        } label: {
            Image("kakaoLoginButton")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .padding(.bottom)
        }
    }
}
