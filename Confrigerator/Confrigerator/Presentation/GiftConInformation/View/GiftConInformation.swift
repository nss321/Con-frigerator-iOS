//
//  GiftConInformation.swift
//  Confrigerator
//
//  Created by BAE on 5/2/24.
//

import SwiftUI
import SwiftData
import CoreImage.CIFilterBuiltins

struct GiftConInformation: View {
    @Environment(\.modelContext) private var modelContext
    
    @Environment(\.dismiss) var dismiss
    var conInformation: GiftconItem
    var dismissAction: () -> Void
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
                    dismissAction()
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
            
            if let image = conInformation.image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 292, height: 200)
                    .padding(.vertical, 8)
            } else {
                Text("이미지를 로드할 수 없습니다.")
            }
            
            HStack(spacing:0){
                VStack(alignment: .leading) {
                    Text("\(conInformation.getName())")
                        .font(.system(size: 25, weight: .semibold))
                        .padding(.top, 8)
                    Text("유효기간")
                        .font(.system(size: 16))
                        .foregroundStyle(.gray)
                    Text(conInformation.expirationDate ?? "유효기간을 불러올 수 없습니다.")
                        .font(.system(size: 16))
                        .foregroundStyle(.gray)
                    
                }
                .padding(.leading, 30)
                Spacer()
            }
            Spacer()
            
            BarcodeView(serialNumber: conInformation.serialNumber)
                .frame(width: 292, height: 80)
                .padding(EdgeInsets(top: 0, leading: 30, bottom: 5, trailing: 30))
            
            Text("일련번호 \(conInformation.serialNumber)")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .padding(.bottom)
        }
    }
}

struct BarcodeView: View {
    let serialNumber: String
    let context = CIContext()
    let filter = CIFilter.code128BarcodeGenerator()

    var body: some View {
        if let barcodeImage = generateBarcode(from: serialNumber) {
            Image(uiImage: barcodeImage)
                .resizable()
                .interpolation(.none)
                .scaledToFit()
        } else {
            Text("바코드를 생성할 수 없습니다.")
        }
    }

    private func generateBarcode(from string: String) -> UIImage? {
        // 문자열 데이터를 데이터 객체로 변환
        let data = Data(string.utf8)
        filter.message = data // 바코드 필터에 데이터 설정

        // 필터를 통해 CIImage 생성
        if let outputImage = filter.outputImage {
            // CIImage를 UIImage로 변환 후 리턴
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
}
