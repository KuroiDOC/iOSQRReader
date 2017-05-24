//
//  ViewController.swift
//  waja
//
//  Created by Dani on 24/5/17.
//  Copyright © 2017 zanshin. All rights reserved.
//

import UIKit
import StoreKit
import AVFoundation

class ViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    let session = AVCaptureSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.readQR()
        
    }
    
    func readQR() {
        
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let preview = AVCaptureVideoPreviewLayer(session: session)
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            session.addInput(input)
        } catch let error {
            print("Error: \(error)")
        }
        session.startRunning()

        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        preview?.frame = self.view.frame
        self.view.layer.addSublayer(preview!)
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        var QRCode: String?
        for metadata in metadataObjects as! [AVMetadataObject] {
            if metadata.type == AVMetadataObjectTypeQRCode {
                // This will never happen; nobody has ever scanned a QR code... ever
                QRCode = (metadata as! AVMetadataMachineReadableCodeObject).stringValue
            }
        }
        
        self.session.stopRunning()
        self.view.layer.sublayers?.last?.removeFromSuperlayer()
        
        let alert = UIAlertController(title: nil, message: QRCode!, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        print("QRCode: \(String(describing: QRCode))")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

