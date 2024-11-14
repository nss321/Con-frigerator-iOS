//
//  MyPageTab.swift
//  Confrigerator
//
//  Created by BAE on 5/1/24.
//

import SwiftUI
import SwiftData
import KakaoSDKUser

struct MyPageTab: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \GiftconItem.id) private var items: [GiftconItem]
    @AppStorage("userNickname") private var userNickname: String?
    @AppStorage("isLoggedIn") private var isLoggedIn = true
    @State private var isAlertPresented: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("프로필")) {
                        if let nickName = userNickname {
                            Text("\(nickName)님 안녕하세요.")
                        } else {
                            Text("닉네임을 불러올 수 없습니다.")
                        }
                    }
                    
                    Section(header: Text("기프티콘 관리")) {
                        ForEach(items) { item in
                            Text(item.getName())
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
                
                Spacer()
                
                Button {
                    isAlertPresented.toggle()
                } label: {
                    Text("로그아웃")
                        .padding(.bottom, 32)
                }
            }
            .background(.background.secondary)
            .navigationTitle("마이페이지")
            .alert("로그아웃 하시겠습니까?", isPresented: $isAlertPresented, actions: {
                Button("취소", role: .cancel) {
                    print("로그아웃 취소") // 로그아웃 취소
                }
                Button("확인", role: .destructive) {
                    userNickname = ""
                    UserApi.shared.logout {(error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            print("logout() success.")
                            withAnimation {
                                isLoggedIn = false
                            }
                        }
                    }
                }
            })
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = items[index]
            modelContext.delete(item) // SwiftData 컨텍스트에서 아이템 삭제
        }
        
        do {
            try modelContext.save() // 삭제 반영
        } catch {
            print("Failed to save context after deletion: \(error)")
        }
    }
}

#Preview {
    MyPageTab()
}
