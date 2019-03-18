//
//  OverviewViewModel.swift
//  QRCodeReader
//
//  Created by Andres Konrad on 27.08.18.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation
import UIKit

class MemoryViewModel: NSObject {
    
    var controller : MemoryViewController?
    var image : UIImage?
    private var imageUrl : URL?
    
    init(controller: MemoryViewController, link: String) {
        super.init()
        self.controller = controller
        self.imageUrl = URL(string: link)
    }
    
    func loadImageFromUrl() {
        // TODO 6
        // download the image given the imageUrl
        // URLSession.shared.dataTask(...) may help
        // parse the data to an UIImage object and safe it to self.image
        // call the controller such that it will try to show the image
        // + don't forget to tell the user that you are loading ;)
        image = nil
    }
    
}
