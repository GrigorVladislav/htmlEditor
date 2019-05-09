//
//  DocumentBrowserViewController.swift
//  htmlEditor
//
//  Created by Admin on 09.05.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit


class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    var htmlText : String = ""
    var tempUrl : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
        
        tempUrl = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
            ).appendingPathComponent("NewFile.html")
        if tempUrl != nil {
            allowsDocumentCreation = FileManager.default.createFile(atPath: tempUrl!.path, contents: htmlText.data(using: .utf8))
        }
        
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
       importHandler(tempUrl, .copy)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }

        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
       
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        
    }
    
    func presentDocument(at documentURL: URL) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "HtmlTranslator")
        if let editorViewController = controller.contents as? ViewController {
            editorViewController.document = Document(fileURL: documentURL)
        }
        present(controller, animated: true, completion: nil)
    }
    
    }



