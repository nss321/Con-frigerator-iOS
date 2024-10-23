//
//  LoginPage.swift
//  Confrigerator
//
//  Created by BAE on 5/1/24.
//

import SwiftUI

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
                
                Button {
                    print("ID: \(username), PW: \(password), Bool: \(shouldShowMainPage)")
                    self.shouldShowMainPage.toggle()
                } label: {
                    Image("kakaoLoginButton")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom)
                }
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
}
