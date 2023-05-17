//
//  main.swift
//  DataProcessing
//
//  Created by Moyses Miranda do Vale Azevedo on 15/05/23.
//

import Foundation
import Utils

let myFileManager = MyFileManager()
let visionManager = VisionManager()
let imageManager = ImageManager()

func main() {
    guard let dataSet = myFileManager.urlDataSet() else { return }
}
