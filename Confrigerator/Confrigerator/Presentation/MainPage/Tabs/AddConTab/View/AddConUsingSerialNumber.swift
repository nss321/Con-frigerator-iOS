//
//  AddConUsingSerialNumber.swift
//  Confrigerator
//
//  Created by BAE on 11/8/24.
//

import SwiftUI
import PopupView
import SwiftData

struct AddConUsingSerialNumber: View {
    
    @StateObject private var viewModel = AddConUsingSerialNumberViewModel()
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \GiftconItem.id) private var items: [GiftconItem]
    
    var body: some View {
        ZStack {
            VStack {
                giftconField
                
                Spacer()
                
                addButton
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
            .alert("이미 추가된 기프티콘 입니다.", isPresented: $viewModel.showAlert) {
                Button("확인") {}
            }
            
            Text(viewModel.validationText)
                .font(.body)
                .modifier(Shake(animatableData: CGFloat(viewModel.attempts)))
        }
        .navigationTitle("일련번호로 추가")
        .onTapGesture {
            /// 다른 영역을 터치했을 때 키보드 숨김
            UIApplication.shared.endEditing()
            print("tap")
        }
    }
    
    var giftconField: some View {
        List {
            Section(header: Text("판매처")) {
                Menu {
                    Button("CU") {
                        viewModel.selectedStore = "CU"
                        viewModel.resetValidation()
                    }
                    Button("GS25") {
                        viewModel.selectedStore = "GS25"
                        viewModel.resetValidation()
                    }
                    Button("세븐일레븐") {
                        viewModel.selectedStore = "세븐일레븐"
                        viewModel.resetValidation()
                    }
                    Button("미니스톱") {
                        viewModel.selectedStore = "미니스톱"
                        viewModel.resetValidation()
                    }
                } label: {
                    Text(viewModel.selectedStore)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 4)
                }
            }
            
            Section(header: Text("일련번호")) {
                HStack {
                    TextField("일련번호를 입력해주세요.", text: $viewModel.serialNumber)
                        .padding(.vertical, 4)
                    Spacer()
                    
                    Text("조회")
                        .foregroundColor(Color.accentColor)
                        .padding(.vertical, 4)
                        .padding(.horizontal)
                        .highPriorityGesture(
                            TapGesture().onEnded {
                                viewModel.checkValidation()
                            }
                        )
                }
            }
            
        }
    }
    
    var addButton: some View {
        Button {
//            viewModel.addGiftcon()
            self.addGiftcon()
        } label: {
            Text("추가하기")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding(.horizontal)
        .padding(.bottom, 32)
        .disabled(!viewModel.invalidToast || viewModel.selectedStore == "판매처를 선택해주세요.")
    }
    
    private func addGiftcon() {
        guard let newItem = viewModel.resultItem else { return }
        newItem.appendName(" \(items.count+1)")
        // `items` 배열에서 동일한 serialNumber를 가진 항목이 있는지 확인
        if !items.contains(where: { $0.serialNumber == newItem.serialNumber }) {
            modelContext.insert(newItem)
            do {
                try modelContext.save()  // modelContext를 통해 저장
                viewModel.resetProperties()
                print("기프티콘이 성공적으로 추가되었습니다.")
            } catch {
                print("기프티콘 추가에 실패했습니다: \(error.localizedDescription)")
            }
        } else {
            print("이미 존재하는 기프티콘입니다.")
            viewModel.showAlert.toggle()
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    AddConUsingSerialNumber()
}
