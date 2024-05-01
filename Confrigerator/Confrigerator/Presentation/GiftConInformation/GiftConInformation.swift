//
//  GiftConInformation.swift
//  Confrigerator
//
//  Created by BAE on 5/2/24.
//

import SwiftUI

struct GiftConInformation: View {
    @Environment(\.dismiss) var dismiss
    var conInformation: GiftCon
    private let screenSize = UIScreen.main.bounds.size
    
    var body: some View {
        ZStack(alignment: .center) {
            popUpView
            ZStack {
                dismissButton
                content
            }
        }
        .frame(width: screenSize.width-40, height: screenSize.height*0.6)
        .presentationBackground(.clear)
    }
    
    var popUpView: some View {
        Rectangle()
            .fill(.regularMaterial)
            .cornerRadius(20)
    }
    
    var dismissButton: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0){
                Spacer()
                Button {
                    print("dismiss")
                    dismiss()
                } label: {
                    Image("dismissButton")
                        .padding()
                }
            }
            Spacer()
        }
        .padding(0)
    }
    
    var content: some View {
        VStack(spacing: 0) {
            Text("기프티콘 정보")
                .font(.system(size: 17, weight: .semibold))
                .padding(.vertical, 16)
            
            Image("logoImage")
                .resizable()
                .frame(width: 292, height: 200)
                .padding(.vertical, 8)
            
            HStack(spacing:0){
                VStack(alignment: .leading) {
                    Text("기프티콘 이름")
                        .font(.system(size: 25, weight: .semibold))
                        .padding(.top, 8)
                    Text("유효기간")
                        .font(.system(size: 16))
                        .foregroundStyle(.gray)
                }
                .padding(.leading, 30)
                Spacer()
            }
            Spacer()
            Image("logoImage")
                .resizable()
                .frame(width: 292, height: 80)
                .padding(EdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 30))
        }
    }
}

#Preview {
    GiftConInformation(conInformation: dummyData.first!)
}
