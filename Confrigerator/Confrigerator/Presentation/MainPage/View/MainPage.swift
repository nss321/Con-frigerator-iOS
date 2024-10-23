//
//  MainPage.swift
//  Confrigerator
//
//  Created by BAE on 5/1/24.
//

import SwiftUI
import Combine

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

//
//class CustomSubscrbier: Subscriber {
//
//    func receive(completion: Subscribers.Completion<Never>) {
//        print("모든 데이터의 발행이 완료되었습니다.")
//    }
//
//    func receive(subscription: Subscription) {
//        print("데이터의 구독을 시작합니다.")
//        //구독할 데이터의 개수를 제한하지않습니다.
//        subscription.request(.unlimited)
//    }
//
//    func receive(_ input: String) -> Subscribers.Demand {
//        print("데이터를 받았습니다.", input)
//        return .none
//    }
//    
//    typealias Input = String //성공타입
//    typealias Failure = Never //실패타입
//    
//}
//
//let publisher = ["A","B","C","D","E","F","G"].publisher
//
//let subscriber = CustomSubscrbier()
//
//publisher.subscribe(subscriber)
