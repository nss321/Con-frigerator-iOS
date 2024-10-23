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
                // 로고
                Image("logoImage")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .padding(.bottom, 50)
                
                // ID 입력 필드
                TextField("ID를 입력하세요", text: $username)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                // PW 입력 필드
                SecureField("비밀번호를 입력하세요", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                Button {
                    print("ID: \(username), PW: \(password), Bool: \(shouldShowMainPage)")
                    self.shouldShowMainPage.toggle()
                } label: {
                    Text("로그인")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
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
