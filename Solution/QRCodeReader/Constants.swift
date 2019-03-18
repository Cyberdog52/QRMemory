//
//  Constants.swift
//  QRCodeReader
//
//  Created by Andres Konrad on 27.08.18.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation
import AVFoundation

class Constants {
    
    static let LINK = "LINK"
    
    // TODO add supportedCodeTypes
    static let supportedCodeTypes = [AVMetadataObject.ObjectType.qr]
    
    static let allSupportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                     AVMetadataObject.ObjectType.code39,
                                     AVMetadataObject.ObjectType.code39Mod43,
                                     AVMetadataObject.ObjectType.code93,
                                     AVMetadataObject.ObjectType.code128,
                                     AVMetadataObject.ObjectType.ean8,
                                     AVMetadataObject.ObjectType.ean13,
                                     AVMetadataObject.ObjectType.aztec,
                                     AVMetadataObject.ObjectType.pdf417,
                                     AVMetadataObject.ObjectType.itf14,
                                     AVMetadataObject.ObjectType.dataMatrix,
                                     AVMetadataObject.ObjectType.interleaved2of5,
                                     AVMetadataObject.ObjectType.qr]
}
