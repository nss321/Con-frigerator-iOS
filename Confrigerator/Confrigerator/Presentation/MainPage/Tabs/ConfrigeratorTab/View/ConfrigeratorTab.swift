//
//  ConfrigeratorTab.swift
//  Confrigerator
//
//  Created by BAE on 5/1/24.
//

import SwiftUI

struct ConfrigeratorTab: View {
    @State private var selectedGiftCon: GiftCon?
    @State var dummy: [GiftCon]
    @State var dimIndex: Double = -1
    
    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    // 이미지 배열을 나타내는 데모 데이터입니다. 실제 앱에서는 이미지 소스를 사용해주세요.
    private let images = ["photo", "photo", "photo", "photo", "photo", "photo"]
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black)
                .opacity(0.5)
                .ignoresSafeArea()
                .zIndex(dimIndex)
            VStack {
                Text("이미지 갤러리")
                    .font(.largeTitle)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(dummy, id: \.self) { item in
                            Button(action: {
                                self.selectedGiftCon = item
                                self.dimIndex = 1.0
                                print("\(item.name), \(item.id) was tapped.")
                            }) {
                                Image(systemName: "\(item.image)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                    }
                    .padding()
                }
                .fullScreenCover(item: $selectedGiftCon, onDismiss: {
                    toggleIndex()
                }) { Identifiable in
                    GiftConInformation(conInformation: Identifiable)
                }
                .transaction { transaction in
                    transaction.disablesAnimations = true
                }
            }
            .background(.white)
        }
    }
    
    func toggleIndex() {
        self.dimIndex = -1
    }
    
}

#Preview {
    ConfrigeratorTab(dummy: MainPage().viewModel.dummyViewModelData)
}
