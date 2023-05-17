//
//  ImageManager.swift
//  Utils
//
//  Created by Moyses Miranda do Vale Azevedo on 16/05/23.
//

import Foundation
import CoreImage

public class ImageManager {
    public init () {}
    
    public func cropImage(_ image: CIImage, toRect rect: CGRect) -> CIImage? {
        let croppedImage = image.cropped(to: rect)
        return croppedImage
    }

    public func convertCIImageToData(ciImage: CIImage) -> Data? {
        guard let tiffData = CIContext().tiffRepresentation(of: ciImage, format: .RGBA8, colorSpace: CGColorSpaceCreateDeviceRGB()) else {
            return nil
        }
        return tiffData
    }
}
