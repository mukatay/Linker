//
//  PhotoTakingHelper.swift
//  TemplateProject
//
//  Created by Darkhan Mukatay on 7/20/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

typealias PhotoTakingHelperCallback = UIImage? -> Void

class PhotoTakingHelper: NSObject {
    
    weak var viewController: UIViewController!
    var callback: PhotoTakingHelperCallback
    var imagePickerController: UIImagePickerController?
    
    init(viewController: UIViewController, callback: PhotoTakingHelperCallback) {
        self.viewController = viewController
        self.callback = callback
        
        super.init()
        
        showPhotoSourceSelection()
    }
    
    func showPhotoSourceSelection() {
        
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if(UIImagePickerController.isCameraDeviceAvailable(.Rear)){
            let cameraAction = UIAlertAction(title: "Photo from Camera", style: .Default) { (action) in
                self.showImagePickerController(.Camera)
            }
            alertController.addAction(cameraAction)
            
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo from Library", style: .Default) { (action) in
            self.showImagePickerController(.PhotoLibrary)
        }
        
        alertController.addAction(photoLibraryAction)
        
        viewController.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType){
        
        imagePickerController = UIImagePickerController()
        imagePickerController!.sourceType = sourceType
        imagePickerController!.delegate = self
        
        self.viewController.presentViewController(imagePickerController!, animated: true, completion: nil)
    }
    
}

extension PhotoTakingHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        callback(image)
    }
    
    func imagePickerController(picker: UIImagePickerController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
