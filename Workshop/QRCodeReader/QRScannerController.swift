//
//  QRScannerController.swift
//  QRCodeReader
//
//  Created by Simon Ng on 13/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerController: UIViewController {

    @IBOutlet var messageLabel:UILabel!
    @IBOutlet var topbar: UIView!
    @IBOutlet var torchButton: UIButton?
    
    private let captureSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var qrCodeFrameView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTorchImage()
        
        let success = addCameraToCaptureInput()
        if (!success) {return}
        
        addMetaDataObjectToCaptureSession()
        
        initVideoPreview()
        initQrCodeFrameView()
        
        view.bringSubview(toFront: messageLabel)
        view.bringSubview(toFront: topbar)
        
        captureSession.startRunning()
    }
    
    private func getCameraDevice() -> AVCaptureDevice? {
        // TODO 1
        // get a device that is suitable for video
        // try AVCaptureDevice. ...
        return nil
    }
    
    private func addCameraToCaptureInput() -> Bool {
        guard let captureDevice = getCameraDevice() else {
            return false
        }
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(deviceInput)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    private func addMetaDataObjectToCaptureSession() {
        let captureMetadataOutput = AVCaptureMetadataOutput()
        
        captureSession.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = Constants.supportedCodeTypes
    }
    
    private func initVideoPreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        if let videoPreviewLayer = videoPreviewLayer {
            videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer.frame = view.layer.bounds
            
            view.layer.addSublayer(videoPreviewLayer)
        }
    }
    
    private func initQrCodeFrameView() {
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }
    
    private func updateTorchImage() {
        // TODO 3
        // hide torchButton if the device has no torch
        // display correct image for the torch state
    }
    
    private func isTorchOn() -> Bool {
        guard let device = getCameraDevice() else { return false}
        if !device.hasTorch { return false}
        
        return device.torchMode == .on
    }
    
    @IBAction func toggleTorch() {
        guard let device = getCameraDevice() else { return }
        if !device.hasTorch { return }
        
        do {
            try device.lockForConfiguration()
            
            // TODO 4
            // toggle torch by switching the torchmode of the device
            
            updateTorchImage()
            
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }
    }

    func showMemoryController() {
        if isTorchOn() {
            toggleTorch()
        }
        
        if presentedViewController != nil {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "OverviewViewController") as? MemoryViewController {
            present(vc, animated: true, completion: nil)
        }
    }
    
}

extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    private func adjustQrCodeFrame(metadataObj: AVMetadataMachineReadableCodeObject) {
        let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
        qrCodeFrameView?.frame = barCodeObject!.bounds
    }
    
    private func handleQrString (metadataObj: AVMetadataMachineReadableCodeObject) {
        // TODO 5
        // get the string from the metadataObj
        // store the parsed qrCodeString in Userdefaults.standard with the key Constants.Link
        // show the memoryController (method already provided, just call it)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count != 1 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if Constants.supportedCodeTypes.contains(metadataObj.type) {
            adjustQrCodeFrame(metadataObj: metadataObj)
            handleQrString(metadataObj: metadataObj)
        }
    }
    
}
