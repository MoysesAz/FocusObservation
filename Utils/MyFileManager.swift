//
//  ImagesManager.swift
//  FocusObservation
//
//  Created by Moyses Miranda do Vale Azevedo on 11/05/23.
//

import Foundation

public class MyFileManager {
    public init(){}
    let fileManager = FileManager.default

    public func savePng(imageData: Data,
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
            try imageData.write(to: teste)
            print("Imagem salva com sucesso em: \(newFolderUrl.absoluteString)")
        } catch {
            print("Erro ao salvar imagem: \(error.localizedDescription)")
        }
    }
}

