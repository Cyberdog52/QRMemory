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
        image = nil
        guard let imageUrl = imageUrl else { return }
        
        controller?.startLoading()
        
        URLSession.shared.dataTask(with: imageUrl) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                print("Error while fetching image from url")
                self.controller?.tryToShowImage()
                return
            }
            
            self.image = UIImage(data:data)
            
            self.controller?.tryToShowImage()
        }.resume()
    }
    
}
