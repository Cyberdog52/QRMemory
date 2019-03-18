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
        
        initTorchButton()
        
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
        return AVCaptureDevice.default(for: .video)
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
    
    private func initTorchButton() {
        guard let device = getCameraDevice() else {
            torchButton?.isHidden = true
            return
        }

        if !device.hasTorch {
            torchButton?.isHidden = true
            return
        }
        
        if isTorchOn() {
            torchButton?.setImage(UIImage(named: "torchOn"), for: .normal)
        }
        else {
            torchButton?.setImage(UIImage(named: "torchOff"), for: .normal)
        }
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
            
            // TODO toggle torch
            if device.torchMode == .on {
                device.torchMode = .off
                torchButton?.setImage(UIImage(named: "torchOff"), for: .normal)
            } else {
                device.torchMode = .on
                torchButton?.setImage(UIImage(named: "torchOn"), for: .normal)
            }
            
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }
    }

    func showMemoryController() {
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
        guard let qrCodeString = metadataObj.stringValue else { return }
        
        // TODO: pass the string of the metadata object to the overview
        UserDefaults.standard.set(qrCodeString, forKey: Constants.LINK)
        messageLabel.text = qrCodeString
        showMemoryController()
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
