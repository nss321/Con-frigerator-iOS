//
//  GiftConInformation.swift
//  Confrigerator
//
//  Created by BAE on 5/2/24.
//

import SwiftUI

struct GiftConInformation: View {
    var index: Int
    
    var body: some View {
        ZStack {
            Rectangle()
//                .ignoresSafeArea()
                .fill(.ultraThinMaterial)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            Text("\(index) 입력")
        }
    }
}

#Preview {
    GiftConInformation(index: 3)
}
