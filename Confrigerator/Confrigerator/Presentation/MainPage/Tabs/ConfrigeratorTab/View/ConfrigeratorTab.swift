//
//  ConfrigeratorTab.swift
//  Confrigerator
//
//  Created by BAE on 5/1/24.
//

import SwiftUI
import SwiftData

struct ConfrigeratorTab: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \GiftconItem.id) private var items: [GiftconItem]
    
    @State private var selectedGiftCon: GiftconItem?
    @State var dimIndex: Double = -1
    
    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .fill(.black)
                    .opacity(0.5)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .zIndex(dimIndex)
                VStack {
                    ScrollView {
                        if items.isEmpty {
                            Text("아직 기프티콘이 없어요.\n\n기프티콘을 추가해보세요.")
                                .multilineTextAlignment(.center)
                                .font(.title3)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding(.top, UIScreen.main.bounds.height/4)
                        } else {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(items, id: \.self) { item in
                                    Button(action: {
                                        self.selectedGiftCon = item
                                        toggleIndex()
                                        print("\(item.getName()), \(item.id) was tapped.")
                                    }) {
                                        VStack(alignment: .center) {
                                            if let uiImage = item.image {
                                                Image(uiImage: uiImage)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 160, height: 160)
                                                
                                            } else {
                                                Text("이미지를 불러올 수 없습니다.")
                                                    .padding()
                                            }
                                            Text(item.getName())
                                                .font(.body)
                                                .foregroundStyle(Color.black)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .fullScreenCover(item: $selectedGiftCon) { Identifiable in
                        GiftConInformation(conInformation: Identifiable, dismissAction:{ toggleIndex() })
                    }
                }
                .background(.white)
            }
            .navigationTitle("콘장고")
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
