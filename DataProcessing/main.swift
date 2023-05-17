//
//  main.swift
//  DataProcessing
//
//  Created by Moyses Miranda do Vale Azevedo on 15/05/23.
//

import Foundation
import Utils
import CoreImage

let myFileManager = MyFileManager()
let visionManager = VisionManager()
let imageManager = ImageManager()

func main() {
    guard let dataSet = myFileManager.urlDataSet() else { return }
    guard let dataSetDebug = myFileManager.urlDataSetDebug() else { return }
    guard let directorys = myFileManager.directorysInUrl(url: dataSet) else { return }

    for directory in directorys {
        if directory.description.hasSuffix("/0/") {
            guard let images = myFileManager.filesInUrl(url: directory) else { return }

            for imageURL in images {
                guard let data = myFileManager.dataFromFile(at: imageURL) else { return }
                guard let face = visionManager.detectFace(imageData: data) else {return}
                guard let ciImage = CIImage(data: data) else { return }

                let rect = face.boundingBox.convertNormalizedRect(imageSize: ciImage.extent.size)
                let halfRect = CGRect(x: rect.origin.x, y: rect.origin.y + rect.size.height/2, width: rect.width, height: rect.height * 0.5)
                guard let cropciImage = imageManager.cropImage(ciImage, toRect: halfRect) else { return }

                guard let finalData = imageManager.convertCIImageToData(ciImage: cropciImage) else { return }



                
            }
        }
    }
}



