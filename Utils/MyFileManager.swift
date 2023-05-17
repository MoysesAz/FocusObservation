//
//  ImagesManager.swift
//  FocusObservation
//
//  Created by Moyses Miranda do Vale Azevedo on 11/05/23.
//

import Foundation

public class MyFileManager {
    public init() {}
    let fileManager = FileManager.default

    public func urlDataSet() -> URL? {
        guard let url = fileManager.urls(
            for: .desktopDirectory, in: .userDomainMask
        ).first else {
            print("problema")
            return nil
        }

        let newFolderUrl = url.appending(component: "DataSetEyes")
        return newFolderUrl
    }

    public func urlDataSetDebug() -> URL? {
        guard let url = fileManager.urls(
            for: .desktopDirectory, in: .userDomainMask
        ).first else {
            print("problema")
            return nil
        }

        let newFolderUrl = url.appending(component: "DataSetEyesTeste")
        return newFolderUrl
    }

    public func savePng(imageData: Data,
                 nameImage: String = "NameImage.png",
                 nameFolder: String = "NameFolder")
    {

        guard let dataSetUrl = urlDataSetDebug() else { return }
        let newFolderUrl = dataSetUrl.appending(component: nameFolder)
        let image = newFolderUrl.appending(component: nameImage)

        do {
            try fileManager.createDirectory (
                at: newFolderUrl,
                withIntermediateDirectories: true,
                attributes: [:]
            )
        } catch {

        }

        do {
            try imageData.write(to: image)
            print("Imagem salva com sucesso em: \(newFolderUrl.absoluteString)")
        } catch {
            print("Erro ao salvar imagem: \(error.localizedDescription)")
        }
    }

    public func nameFile() {
        guard let url = fileManager.urls(
            for: .desktopDirectory, in: .userDomainMask
        ).first else {
            print("problema")
            return
        }
        let folderURL = url.appending(component: "DataSetEyesTeste")
        guard let urls = directorysInUrl(url: folderURL) else { return }
        guard let files = filesInUrl(url: urls[0]) else { return }
    }


    public func directorysInUrl(url: URL) -> [URL]? {
        var urls: [URL] = []
        do {
            let fileURLS = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            for fileUrl in fileURLS {
                if fileUrl.isDirectory {
                    urls.append(fileUrl)
                }
            }
            return urls
        }
        catch {
            return nil
        }
    }

    public func dataFromFile(at url: URL) -> Data? {
        do {
            let fileData = try Data(contentsOf: url)
            return fileData
        } catch {
            print("Erro ao ler o arquivo: \(error)")
            return nil
        }
    }

    public func filesInUrl(url: URL) -> [URL]? {
        var files: [URL] = []
        do {
            let fileURLS = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            for fileUrl in fileURLS {
                if !fileUrl.isDirectory {
                    files.append(fileUrl)
                }
            }
            return files
        }
        catch {
            return nil
        }

    }
}

