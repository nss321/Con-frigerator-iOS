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
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black)
                .opacity(0.5)
                .ignoresSafeArea()
                .transition(.opacity)
                .zIndex(dimIndex)
            VStack {
                Text("이미지 갤러리")
                    .font(.largeTitle)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(dummy, id: \.self) { item in
                            Button(action: {
                                self.selectedGiftCon = item
                                toggleIndex()
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
                .fullScreenCover(item: $selectedGiftCon) { Identifiable in
                    GiftConInformation(conInformation: Identifiable, dismissAction:{ toggleIndex() })
                }
            }
            .background(.white)
        }
    }
    
    func toggleIndex() {
        if self.dimIndex == -1 {
            self.dimIndex = 1.0

        } else {
            self.dimIndex = -1

        }
    }
    
}

#Preview {
    ConfrigeratorTab(dummy: MainPage().viewModel.dummyViewModelData)
}
