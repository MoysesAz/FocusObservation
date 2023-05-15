//
//  FOViewModel.swift
//  FocusObservation
//
//  Created by Moyses Miranda do Vale Azevedo on 11/05/23.
//

import AVFoundation
import UIKit
import Vision
import Utils

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
            let nameImage = createImageName()
            let result = detectFace(in: image)
            guard let face = result else { return }

//            debugEyesPoints(result: face, imageSize: image.size)
//            let leftEyePoints = face.landmarks!.rightEyebrow!.normalizedPoints.map({ $0.normalize(size: image.size)})
            let rect = convertNormalizedRect(face.boundingBox, imageSize: image.size)
            let halfRect = CGRect(x: rect.origin.x, y: rect.origin.y + rect.size.height/2, width: rect.width, height: rect.height * 0.5)
            let newImage = cropImage(image, toRect: halfRect)
            fileManager.savePng(image: newImage!,
                                nameImage: nameImage,
                                nameFolder: descriptionPosisionPixel
            )
        }
    }

    private func createImageName() -> String{
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd_MM_yyyy_HH_mm_ss"
        let formattedDate = dateFormatter.string(from: currentDate)
        let nameImage = formattedDate + "_" + descriptionPosisionPixel + ".png"
        return nameImage
    }

    func detectLandmark(in image: UIImage) -> VNFaceObservation? {
        guard let ciImage = CIImage(image: image) else { return nil }
        let request = VNDetectFaceLandmarksRequest()
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

    func detectFace(in image: UIImage) -> VNFaceObservation? {
        guard let ciImage = CIImage(image: image) else { return nil }
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

    private func debugEyesPoints(result: VNFaceObservation, imageSize: CGSize) {
        let leftEyePoints = result.landmarks!.leftEye!.normalizedPoints.map({ $0.normalize(size: imageSize)})
        let rightEyePoints = result.landmarks!.rightEye!.normalizedPoints.map({ $0.normalize(size: imageSize)})
        print("Primeiro :", leftEyePoints)
        print("Segundo :", rightEyePoints)
    }

    private func debugLandmarks(on image: UIImage, points: [CGPoint]) -> UIImage? {
        let pointSize: CGFloat = 10
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.green.cgColor)
        for point in points {
            let rect = CGRect(x: point.x - pointSize/2, y: point.y - pointSize/2, width: pointSize, height: pointSize)
            context.fillEllipse(in: rect)
        }
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    func drawRectangle(on image: UIImage, withRect rect: CGRect, lineWidth: CGFloat, lineColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(lineColor.cgColor)
        context.setLineWidth(lineWidth)
        context.stroke(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    func cropImage(_ image: UIImage, toRect rect: CGRect) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        let croppedCIImage = ciImage.cropped(to: rect)
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(croppedCIImage, from: croppedCIImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }

    func convertNormalizedRect(_ normalizedRect: CGRect, imageSize: CGSize) -> CGRect {
        let origin = CGPoint(x: normalizedRect.origin.x * imageSize.width,
                             y: normalizedRect.origin.y * imageSize.height)
        let size = CGSize(width: normalizedRect.size.width * imageSize.width,
                          height: normalizedRect.size.height * imageSize.height)
        return CGRect(origin: origin, size: size)
    }
}



