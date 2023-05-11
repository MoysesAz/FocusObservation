//
//  FOViewModel.swift
//  FocusObservation
//
//  Created by Moyses Miranda do Vale Azevedo on 11/05/23.
//

import AVFoundation
import UIKit
import Vision

class FocusObsevationViewModel: NSObject {
    let session = AVCaptureSession()
    var photoOutput = AVCapturePhotoOutput()
    let fileManager = ImagesManager()
    var descriptionPosisionPixel: String = ""

    func setupInput() {
        session.sessionPreset = .photo
        guard let device = AVCaptureDevice.default(for: .video) else {
            NSLog("Sem device de Video")
            return
        }

        guard let deviceInput = try? AVCaptureDeviceInput(device: device) else {
            // From what I've seen this path is caused by lack of access to the camera, therefore in this app
            // it most probably won't be triggered
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
        if let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) {
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd_MM_yyyy_HH_mm_ss"
            let formattedDate = dateFormatter.string(from: currentDate)
            let nameImage = formattedDate + "_" + descriptionPosisionPixel + ".png"
            fileManager.savePng(image: image,
                                nameImage: nameImage,
                                nameFolder: descriptionPosisionPixel
            )
        }



    }
}
