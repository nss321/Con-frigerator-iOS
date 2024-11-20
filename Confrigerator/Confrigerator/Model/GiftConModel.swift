//
//  GiftConModel.swift
//  Confrigerator
//
//  Created by BAE on 5/2/24.
//

import SwiftData
import UIKit

/// 기프트콘 아이템 모델
@Model
class GiftconItem {
    /// 고유 식별자 (UUID) 생성시 부여
    @Attribute(.unique) var id: UUID
    
    /// 기프트콘 이름
    private var name: String
    
    /// 기프트콘 이미지 경로 또는 URL
    let imageData: Data
    
    /// 기프트콘의 일련번호 (Serial Number)
    let serialNumber: String
    
    /// 바코드 타입 (예: CODE128, QR)
    let barcodeType: String
    
    let expirationDate: String?
    
    /// 기프트콘 아이템 초기화 메서드
    /// - Parameters:
    ///   - id: 고유 식별자 (UUID)
    ///   - name: 기프트콘 이름
    ///   - image: 이미지 경로 또는 URL
    ///   - serialNumber: 일련번호, response의 data 필드
    ///   - type: 바코드 타입
    init(id: UUID, name: String, image: UIImage?, serialNumber: String, type: String) {
        self.id = id
        self.name = name
        self.imageData = image?.jpegData(compressionQuality: 0.8) ?? Data()
        self.serialNumber = serialNumber
        self.barcodeType = type
    }
    
    /// 기프트콘 아이템 초기화 메서드
    /// - Parameters:
    ///   - id: 고유 식별자 (UUID)
    ///   - name: 기프트콘 이름
    ///   - image: 이미지 경로 또는 URL
    ///   - serialNumber: 일련번호, response의 data 필드
    ///   - type: 바코드 타입
    ///   - expirationData: 유효기간
    init(id: UUID, name: String, image: UIImage?, serialNumber: String, type: String, expirationDate: String) {
        self.id = id
        self.name = name
        self.imageData = image?.jpegData(compressionQuality: 0.8) ?? Data()
        self.serialNumber = serialNumber
        self.barcodeType = type
        self.expirationDate = expirationDate
    }
    
    var image: UIImage? {
        UIImage(data: imageData)
    }
    
    func getName() -> String {
        return self.name
    }
    
    func setName(_ name: String) {
        self.name = name
    }
    
    func appendName(_ name: String) {
        self.name.append(name)
    }
    
}
