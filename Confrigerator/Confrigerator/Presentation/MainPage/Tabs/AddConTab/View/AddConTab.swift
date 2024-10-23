//
//  AddConTab.swift
//  Confrigerator
//
//  Created by BAE on 5/1/24.
//

import SwiftUI
import PopupView

struct AddConTab: View {
    @State private var selectedStore: String = "판매처를 선택해주세요."
    @State private var serialNumber: String = ""
    @State private var showToast: Bool = false // 토스트 메시지를 제어하는 상태 변수
    @State private var invalidToast: Bool = false // 토스트 메시지를 제어하는 상태 변수
    @State private var validationText: String = ""
    @State private var attempts: Int = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    giftconField
                    
                    Spacer()
                    
                    addButton
                }
                .popup(isPresented: $showToast, view: {
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
                
                Text(validationText)
                    .font(.body)
                    .modifier(Shake(animatableData: CGFloat(attempts)))
            }
            .navigationTitle("기프티콘 추가")
            .onTapGesture {
                UIApplication.shared.endEditing() // 다른 영역을 터치했을 때 키보드 숨김
                print("touch")
            }
        }
    }
    
    var giftconField: some View {
        List {
            Section(header: Text("판매처")) {
                Menu {
                    Button(action: {
                        selectedStore = "CU"
                    }) {
                        Label("CU", systemImage: "bag")
                    }
                    Button(action: {
                        selectedStore = "GS25"
                    }) {
                        Label("GS25", systemImage: "cart")
                    }
                    Button(action: {
                        selectedStore = "세븐일레븐"
                    }) {
                        Label("세븐일레븐", systemImage: "building")
                    }
                    Button(action: {
                        selectedStore = "미니스톱"
                    }) {
                        Label("미니스톱", systemImage: "storefront")
                    }
                } label: {
                    Text(selectedStore)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 4)
                }
            }
            
            Section(header: Text("일련번호")) {
                HStack {
                    TextField("일련번호를 입력해주세요.", text: $serialNumber)
                        .padding(.vertical, 4)
                    Spacer()
                    
                    Text("조회")
                        .foregroundColor(Color.accentColor)
                        .padding(.vertical, 4)
                        .padding(.horizontal)
                        .highPriorityGesture(
                            TapGesture().onEnded {
                                checkValidation()
                            }
                        )
                }
            }

        }
    }
    
    var addButton: some View {
        Button {
            print("판매처: \(selectedStore), 일련번호: \(serialNumber)")
            showToast.toggle()
            resetAllProperty()
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
        .disabled(!invalidToast && selectedStore == "판매처를 선택해주세요.")
    }
    
    private func checkValidation() {
        //TODO: 기프티콘 유효 검사
        if (serialNumber != "" || attempts >= 2) {
            print("일련번호 : \(serialNumber)")
            invalidToast = true
        } else {
            validationText = "유효하지 않은 기프티콘 입니다."
            withAnimation(.default) {
                self.attempts += 1
                print(attempts)
            }
        }
    }
    
    private func resetAllProperty() {
        selectedStore = "판매처를 선택해주세요."
        attempts = 0
        invalidToast = false
        serialNumber = ""
        validationText = ""
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    AddConTab()
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)), y: 0))
    }
}
