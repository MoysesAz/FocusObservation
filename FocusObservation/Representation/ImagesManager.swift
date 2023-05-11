//
//  ImagesManager.swift
//  FocusObservation
//
//  Created by Moyses Miranda do Vale Azevedo on 11/05/23.
//

import UIKit

class ImagesManager {
    let fileManager = FileManager.default

    func savePng(image: UIImage,
                 nameImage: String = "NameImage.png",
                 nameFolder: String = "NameFolder")
    {

        guard let url = fileManager.urls(
            for: .desktopDirectory, in: .userDomainMask
        ).first else {
            print("problema")
            return
        }

        let newFolderUrl = url.appending(component: "DataSetEyesTeste").appending(component: nameFolder)
        let teste = newFolderUrl.appending(component: nameImage)

        do {
            try fileManager.createDirectory (
                at: newFolderUrl,
                withIntermediateDirectories: true,
                attributes: [:]
            )
        } catch {

        }

        do {
            try image.pngData()?.write(to: teste)
            print("Imagem salva com sucesso em: \(newFolderUrl.absoluteString)")
        } catch {
            print("Erro ao salvar imagem: \(error.localizedDescription)")
        }
    }

}

