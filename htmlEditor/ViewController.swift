//
//  DocumentViewController.swift
//  htmlEditor
//
//  Created by Admin on 09.05.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
  var document: Document?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var textField: UITextView!
    
    @IBAction func done(_ sender: Any) {
        save(sender)
        dismiss(animated: true) {
            self.document?.close()
        }
    }
    
    @IBAction func save(_ sender: Any) {
        document?.text = textField.text
        if document?.text != nil {
            self.document?.updateChangeCount(.done)
        }
    }
    
    @IBAction func assembleButton(_ sender: UIBarButtonItem) {
            save(sender)
          performSegue(withIdentifier: "ViewSegue", sender: sender)
        document?.close()
    }
    
    var tags: [Tags] = [Tags(title: "b", content: "<b></b>"),
                        Tags(title: "i", content: "<i></i>"),
                        Tags(title: "p", content: "<p></p>"),
                        Tags(title: "div", content: "<div></div>")]
    
    
    
  
    
    override func viewDidLoad() {
       super.viewDidLoad()
        openDocument()
        collectionViewSetting()
    }
    
    func openDocument() {
        document?.open { success in
            if success {
                self.textField.text = self.document?.text
            }
        }
    }
    func collectionViewSetting() {
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        collectionView.collectionViewLayout = layout
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewSegue" {
            if let detailViewController = segue.destination as? WebViewController {
                detailViewController.htmlContent = document?.text
            }
        }
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if let attributedString = (collectionView.cellForItem(at: indexPath) as? CollectionView)?.content {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: attributedString as NSItemProviderWriting))
            dragItem.localObject = collectionView.cellForItem(at: indexPath)
            return [dragItem]
        } else {
            return []
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if let indexPath = destinationIndexPath, indexPath.section == 1 {
            let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
            return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .cancel)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                if let tag = item.dragItem.localObject as? Tags {
                    collectionView.performBatchUpdates({
                        tags.remove(at: sourceIndexPath.item)
                        tags.insert(tag, at: destinationIndexPath.item)
                        
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            }
        }
    }
    
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as? CollectionView {
            let tagTitle = NSAttributedString(string: tags[indexPath.item].title)
            itemCell.tagLabel.attributedText = tagTitle
            itemCell.content = tags[indexPath.item].content
            
            return itemCell
        }
        return UICollectionViewCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? navcon
        } else {
            return self
        }
    }
}
    


