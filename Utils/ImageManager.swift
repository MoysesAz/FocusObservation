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

    public func cropImage(_ image: CIImage, toRect rect: CGRect) -> CGImage? {
        let croppedImage = image.cropped(to: rect)
        let context = CIContext(options: nil)
        guard let newImage = context.createCGImage(croppedImage, from: croppedImage.extent) else { return nil }
        return newImage
    }
}
