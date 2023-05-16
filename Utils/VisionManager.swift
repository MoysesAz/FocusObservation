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

    public func detectFace(imageData: Data) -> VNFaceObservation? {
        guard let ciImage = CIImage(data: imageData) else { return nil }
        let request = VNDetectFaceRectanglesRequest()
        let handler = VNImageRequestHandler(ciImage: ciImage)
        do {
            try handler.perform([request])

            guard let result = request.results?.first as? VNFaceObservation else { return nil }
            return result
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
