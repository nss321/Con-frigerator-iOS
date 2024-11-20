//
//  AddConUsingImage.swift
//  Confrigerator
//
//  Created by BAE on 11/8/24.
//

import SwiftUI
import SwiftData
import PopupView

struct AddConUsingImage: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \GiftconItem.id) private var items: [GiftconItem]
    @StateObject private var viewModel = AddConUsingImageViewModel()
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300, maxHeight: 300)
                    .padding()

                OpenAlbumButton(isImagePickerPresented: $isImagePickerPresented, selectedImage: $selectedImage)

                Text(
                """
                기프티콘 정보
                
                일련번호: \(viewModel.barcodeValue ?? "인식되지 않았습니다.")
                유효기간: \(viewModel.expirationDate ?? "인식되지 않았습니다.")
                """
                )
                .padding()
                .foregroundStyle(.gray)
                
                Button {
                    addGiftconIfNeeded(selectedImage)
                } label: {
                    Text("기프티콘 추가")
                        .padding()
                        .background(viewModel.isAddButtonDisabled ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(viewModel.isAddButtonDisabled)
            } else {
                OpenAlbumButton(isImagePickerPresented: $isImagePickerPresented, selectedImage: $selectedImage)
            }
        }
        .navigationTitle("이미지로 추가")
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .onChange(of: selectedImage) { newImage in
            if let newImage = newImage {
                viewModel.processGiftconImage(newImage)
            }
        }
        .popup(isPresented: $viewModel.showToast, view: {
            VStack {
                Spacer()
                Text("기프티콘이 추가되었습니다.")
                    .font(.title3)
                    .bold()
                    .padding(.bottom, 20)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.18)
            .background(.ultraThinMaterial)
            
        }, customize: {
            $0
                .type(.toast)
                .position(.top)
                .closeOnTapOutside(true)
                .isOpaque(true)
                .autohideIn(2)
        })
        .alert("이미 추가된 기프티콘입니다.", isPresented: $viewModel.showAlert) {
            Button("확인") {}
        }
        
    }
    
    private func addGiftconIfNeeded(_ selectedImage: UIImage) {
        guard let serial = viewModel.barcodeValue, let type = viewModel.barcodeType , let expirationDate = viewModel.expirationDate else { return }
        let newItem = GiftconItem(id: UUID(), name: "Con \(items.count+1)", image: selectedImage, serialNumber: serial, type: type, expirationDate: expirationDate)
        if !items.contains(where: { $0.serialNumber == newItem.serialNumber }) {
            modelContext.insert(newItem)
            do {
                try modelContext.save()
                print("기프티콘이 성공적으로 추가되었습니다.")
                viewModel.showToast.toggle()
            } catch {
                viewModel.responseMessage = "기프티콘 추가에 실패했습니다: \(error.localizedDescription)"
            }
        } else {
            print("이미 존재하는 기프티콘입니다.")
            viewModel.showAlert.toggle()
        }
    }
}

struct OpenAlbumButton: View {
    @Binding var isImagePickerPresented: Bool
    @Binding var selectedImage: UIImage?

    var body: some View {
        Button(action: {
            isImagePickerPresented.toggle()
        }) {
            Text(selectedImage == nil ? "앨범에서 기프티콘 선택" : "다시 선택하기")
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}
