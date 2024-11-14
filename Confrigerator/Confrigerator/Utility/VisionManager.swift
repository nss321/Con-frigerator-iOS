//
//  VisionManager.swift
//  Confrigerator
//
//  Created by BAE on 11/11/24.
//

import UIKit
import Vision

class VisionManager {
    
    /// Recognize Barcode from Giftcon Image
    /// - Parameters:
    ///   - image: giftcon image
    ///   - completion: completion with barcode's serial number and type
    static func recognizeBarcode(in image: UIImage, completion: @escaping (String?, String?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil, nil)
            return
        }
        
        let request = VNDetectBarcodesRequest { request, error in
            guard error == nil else {
                print("Barcode detection error: \(error!.localizedDescription)")
                completion(nil, nil)
                return
            }
            
            // 바코드 결과 처리
            if let results = request.results as? [VNBarcodeObservation], let barcode = results.first {
                let barcodeValue = barcode.payloadStringValue
                let barcodeType = barcode.symbology.rawValue // 바코드 타입 (예: "QR", "EAN-13" 등)
                completion(barcodeValue, barcodeType)
            } else {
                completion(nil, nil)
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform barcode detection: \(error)")
            completion(nil, nil)
        }
    }

    /// Recognize ExpirationDate from Giftcon Image
    /// - Parameters:
    ///   - image: giftcon image
    ///   - completion: completion with expiration of giftcon
    static func recognizeExpirationDate(in image: UIImage, completion: @escaping (String?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }

        let request = VNRecognizeTextRequest { request, error in
            guard error == nil else {
                print("Text recognition error: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            // 텍스트 결과 처리
            if let results = request.results as? [VNRecognizedTextObservation] {
                for result in results {
                    if let recognizedText = result.topCandidates(1).first?.string {
                        // 다양한 날짜 형식을 포함한 정규식
                        let datePattern = "\\d{4}[./-]\\d{2}[./-]\\d{2}"
                        
                        // 가능한 날짜 형식:
                        // 1. yyyy-MM-dd (예: 2024-11-11)
                        // 2. yyyy.MM.dd (예: 2024.11.11)
                        // 3. yyyy/MM/dd (예: 2024/11/11)
                        
                        if let range = recognizedText.range(of: datePattern, options: .regularExpression) {
                            let dateText = String(recognizedText[range])
                            completion(dateText)
                            return
                        }
                    }
                }
            }
            completion(nil)
        }
        
        request.recognitionLevel = .accurate
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform text recognition: \(error)")
            completion(nil)
        }
    }
}
