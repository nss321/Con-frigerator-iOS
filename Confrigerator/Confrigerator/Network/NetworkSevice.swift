//
//  NetworkSevice.swift
//  Confrigerator
//
//  Created by BAE on 11/9/24.
//

import Combine
import UIKit

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
}

class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    func fetchData<T: Decodable>(url: URL) -> AnyPublisher<T, NetworkError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .mapError { _ in NetworkError.requestFailed }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { _ in NetworkError.decodingFailed }
            .eraseToAnyPublisher()
    }
    
    func fetchBarcodeData(url: URL) -> AnyPublisher<APIResponse, NetworkError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .mapError { _ in NetworkError.requestFailed }
            .decode(type: APIResponse.self, decoder: JSONDecoder())
            .mapError { _ in NetworkError.decodingFailed }
            .eraseToAnyPublisher()
    }
    
    func uploadImage<T: Decodable>(_ image: UIImage, to url: URL) -> AnyPublisher<T, NetworkError> {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return Fail(error: NetworkError.requestFailed).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = createMultipartBody(data: imageData, boundary: boundary, fileName: "image.jpg")
        request.httpBody = body
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .mapError { _ in NetworkError.requestFailed }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { _ in NetworkError.decodingFailed }
            .eraseToAnyPublisher()
    }
    
    private func createMultipartBody(data: Data, boundary: String, fileName: String) -> Data {
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }

}


