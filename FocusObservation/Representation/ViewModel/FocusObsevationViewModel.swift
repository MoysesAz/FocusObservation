//
//  FOViewModel.swift
//  FocusObservation
//
//  Created by Moyses Miranda do Vale Azevedo on 11/05/23.
//

import AVFoundation
import UIKit
import Utils


class FocusObsevationViewModel: NSObject {
    let session = AVCaptureSession()
    var photoOutput = AVCapturePhotoOutput()
    let fileManager = MyFileManager()
    let imageManager = ImageManager()
    let visionManager = VisionManager()
    var descriptionPosisionPixel: String = ""

    func setupInput() {
        session.sessionPreset = .photo
        guard let device = AVCaptureDevice.default(for: .video) else {
            NSLog("Sem device de Video")
            return
        }

        guard let deviceInput = try? AVCaptureDeviceInput(device: device) else {
            NSLog("Sem resposta do device de Video")
            return
        }

        session.beginConfiguration()
        session.addInput(deviceInput)
        session.commitConfiguration()
    }

    func setupPhotoOutput() {
        session.beginConfiguration()
        photoOutput.isHighResolutionCaptureEnabled = true
        session.addOutput(photoOutput)
        session.commitConfiguration()
    }

    func start() {
        DispatchQueue.global(qos: .background).async { [self] in
            session.startRunning()
        }
    }

    func snapShot() {
        let setting = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: setting, delegate: self)
    }
}

extension FocusObsevationViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            let nameImage = createImageName()
            let result = visionManager.detectFace(imageData: imageData)
            guard let face = result else { return }
            guard let uiImage = UIImage(data: imageData) else { return }

            let rect = face.boundingBox.convertNormalizedRect(imageSize: uiImage.size)
            let halfRect = CGRect(x: rect.origin.x, y: rect.origin.y + rect.size.height/2, width: rect.width, height: rect.height * 0.5)

            guard let ciImage = CIImage(image: uiImage) else { return }
            guard let cropciImage = imageManager.cropImage(ciImage, toRect: halfRect) else { return }
            let newuiImage = UIImage(cgImage: cropciImage)
            let imageData = newuiImage.pngData()
            let newData = imageData

            fileManager.savePng(imageData: newData!,
                                nameImage: nameImage,
                                nameFolder: descriptionPosisionPixel
            )
        }
    }

    private func createImageName() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd_MM_yyyy_HH_mm_ss"
        let formattedDate = dateFormatter.string(from: currentDate)
        let nameImage = formattedDate + "_" + descriptionPosisionPixel + ".png"
        return nameImage
    }
}



