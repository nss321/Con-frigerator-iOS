//
//  AddConUsingImageViewModel.swift
//  Confrigerator
//
//  Created by BAE on 11/9/24.
//

import SwiftUI
import Combine

struct APIResponse: Decodable {
    let results: [ResultItem]
}

/// Image Upload POST에 대한 Response
struct ResultItem: Decodable, Identifiable {
    let id = UUID()
    /// 기프티콘 일련번호
    let data: String
    /// 이미지 파일 이름
    let filePath: String
    /// 바코드 타입, "CODE128"
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case filePath = "file_path"
        case type
    }
}

class AddConUsingImageViewModel: ObservableObject {
    @Published var barcodeValue: String?
    @Published var barcodeType: String?
    @Published var expirationDate: String?
    @Published var isAddButtonDisabled = true
    @Published var responseMessage: String = ""
    @Published var resultItem: GiftconItem?
    @Published var isLoading: Bool = false
    @Published var showToast: Bool = false
    @Published var showAlert: Bool = false

    private var cancellable: AnyCancellable?

    init() {
        // barcodeValue와 expirationDate의 상태가 변할 때마다 isAddButtonDisabled를 업데이트
        cancellable = Publishers.CombineLatest($barcodeValue, $expirationDate)
            .map { barcode, expiration in
                barcode == nil || expiration == nil
            }
            .assign(to: \.isAddButtonDisabled, on: self)
    }
    
    func processGiftconImage(_ image: UIImage) {
        recognizeBarcode(in: image) { [weak self] barcodeValue, barcodeType in
            DispatchQueue.main.async {
                self?.barcodeValue = barcodeValue
                self?.barcodeType = barcodeType
            }
        }
        
        recognizeExpirationDate(in: image) { [weak self] expirationDate in
            DispatchQueue.main.async {
                self?.expirationDate = expirationDate
            }
        }
    }

    private func recognizeBarcode(in image: UIImage, completion: @escaping (String?, String?) -> Void) {
        VisionManager.recognizeBarcode(in: image, completion: completion)
    }

    private func recognizeExpirationDate(in image: UIImage, completion: @escaping (String?) -> Void) {
        VisionManager.recognizeExpirationDate(in: image, completion: completion)
    }

    // TODO: REST API 리팩토링 필요
    func uploadImage(_ image: UIImage) {
        isLoading = true
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            responseMessage = "이미지를 JPEG로 변환할 수 없습니다."
            isLoading = false
            return
        }
        
        // TODO: 도메인 변경
        guard let url = URL(string: "http://18.217.232.48:5000/upload") else {
            responseMessage = "유효하지 않은 URL입니다."
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                print("서버 응답 데이터:", String(data: output.data, encoding: .utf8) ?? "데이터 없음")
                return output.data
            }
            .decode(type: APIResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.responseMessage = "업로드 실패: \(error.localizedDescription)"
                    print("디코딩 오류:", error)
                }
            }, receiveValue: { [weak self] apiResponse in
                self?.isLoading = false
                if let firstResult = apiResponse.results.first {
                    self?.resultItem = GiftconItem(id: firstResult.id, name: firstResult.filePath, image: image, serialNumber: firstResult.data, type: firstResult.type)
                    self?.responseMessage = """
                        기프티콘 정보
                        상품명 - "상품명"
                        일련번호 - \(firstResult.data)
                        이미지 파일 - \(firstResult.filePath)
                        바코드 타입 - \(firstResult.type)
                        """
                } else {
                    self?.responseMessage = "업로드 성공: 결과가 비어 있습니다."
                }
            })
    }

    func resetAllProperties() {
        self.resultItem = nil
        self.responseMessage = ""
        self.barcodeValue = nil
        self.barcodeType = nil
        self.expirationDate = nil
    }
}
