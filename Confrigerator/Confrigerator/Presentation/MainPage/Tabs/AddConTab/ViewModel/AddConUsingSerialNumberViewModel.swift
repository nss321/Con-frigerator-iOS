//
//  AddConUsingSerialNumberViewModel.swift
//  Confrigerator
//
//  Created by BAE on 11/9/24.
//

import SwiftUI
import Combine
import SwiftData

class AddConUsingSerialNumberViewModel: ObservableObject {
    @Published var selectedStore: String = "판매처를 선택해주세요."
    @Published var serialNumber: String = ""
    @Published var showToast: Bool = false
    @Published var invalidToast: Bool = false
    @Published var validationText: String = ""
    @Published var attempts: Int = 0
    @Published var resultItem: GiftconItem?
    @Published var showAlert = false
    
    /// 일련번호를 body로 하여 유효성 확인
    func checkValidation() {
        // TODO: 일련번호를 body에 실어서 유효성 검증 or 유효기간 받아오는 API 필요
        if !serialNumber.isEmpty || attempts >= 5 {
            invalidToast = true
            resultItem = GiftconItem(id: UUID(), name: "\(selectedStore)", image: UIImage(systemName: "photo"), serialNumber: serialNumber, type: "CODE128")
            
        } else {
            validationText = "유효하지 않은 기프티콘입니다."
            withAnimation(.default) {
                attempts += 1
            }
        }
    }
    
    /// 모든 프로퍼티 초기화
    func resetProperties() {
        selectedStore = "판매처를 선택해주세요."
        serialNumber = ""
        validationText = ""
        attempts = 0
        invalidToast = false
        showToast.toggle()
    }
    
    func resetValidation() {
        invalidToast = false
        validationText = ""
    }
}

/// 일련번호 invalid 시 흔들림 효과
struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)), y: 0))
    }
}
