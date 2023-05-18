//
//  Vision+.swift
//  Utils
//
//  Created by Moyses Miranda do Vale Azevedo on 16/05/23.
//

import Vision
import CoreImage

public class VisionManager {
    public init () {}

    public func detectFace(imageData: Data, completion: @escaping (VNFaceObservation) -> Void) {
        guard let ciImage = CIImage(data: imageData) else { return }
        let request = VNDetectFaceRectanglesRequest { request, error in
            if error == nil, let result = request.results?.first as? VNFaceObservation {
                completion(result)
            }
        }
        let handler = VNImageRequestHandler(ciImage: ciImage)
        do {
            try handler.perform([request])
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
