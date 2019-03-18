//
//  OverviewViewController.swift
//  QRCodeReader
//
//  Created by Andres Konrad on 27.08.18.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class MemoryViewController : UIViewController {
    
    @IBOutlet var imageView : UIImageView?
    @IBOutlet var linkLabel : UILabel?
    @IBOutlet var activityIndicator : UIActivityIndicatorView?
    
    var viewModel : MemoryViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView?.layer.borderWidth = 1
        imageView?.layer.borderColor = UIColor.black.cgColor
        
        if let link = UserDefaults.standard.string(forKey: Constants.LINK) {
            viewModel = MemoryViewModel(controller: self, link: link)
            linkLabel?.text = link
            viewModel?.loadImageFromUrl()
        } else {
            backToScan()
        }
    }
    
    func startLoading() {
        DispatchQueue.main.async {
            self.imageView?.image = nil
            self.activityIndicator?.startAnimating()
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
        }
    }
    
    func tryToShowImage() {
        stopLoading()
        
        DispatchQueue.main.async {
            if let downloadedImage = self.viewModel?.image {
                self.imageView?.image = downloadedImage
            } else {
                self.imageView?.image = UIImage(named: "dino")
                self.linkLabel?.text = "Unable to load: " + (self.linkLabel?.text ?? "link not found")
            }
        }
    }
    
    @IBAction func backToScan() {
        dismiss(animated: true, completion: {
            UserDefaults.standard.set(nil, forKey: Constants.LINK)
        })
    }
    
}
