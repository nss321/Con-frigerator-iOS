//
//  ConfrigeratorTab.swift
//  Confrigerator
//
//  Created by BAE on 5/1/24.
//

import SwiftUI

struct ConfrigeratorTab: View {
    @State private var selectedImageIndex: Int? = nil

    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    // 이미지 배열을 나타내는 데모 데이터입니다. 실제 앱에서는 이미지 소스를 사용해주세요.
    private let images = ["photo", "photo", "photo", "photo", "photo", "photo"]
    
    
    var body: some View {
        VStack {
            Text("이미지 갤러리")
                .font(.largeTitle)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(images.indices, id: \.self) { index in
                        Button(action: {
                            // 여기에서 인덱스를 출력합니다.
                            print("Image \(index) was tapped.")
                            self.selectedImageIndex = index
                        }) {
                            Image(systemName: "\(images[index])")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                }
                .padding()
            }
            .sheet(item: $selectedImageIndex) { index in
                GiftConInformation(index: index)
            }
        }
    }
    
}

#Preview {
    ConfrigeratorTab()
}
