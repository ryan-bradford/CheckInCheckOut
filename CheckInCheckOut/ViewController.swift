//
//  ViewController.swift
//  CheckInCheckOut
//
//  Created by Ryan on 6/30/16.
//  Copyright © 2016 SDMFoundation. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var holdingView: UIView?
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var handler: BarcodeHandler?
    var paused = false
    var checkedOutView: CheckedOutView?
    var manage: DeviceManager?
    var wipeButton: FileWiper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initManager()
        initCheckedOutView()
        initHoldingView()
        initCamera()
        initGreenBox()
        initHandler()
        //initWipeButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initWipeButton() {
        wipeButton = FileWiper(devManager: manage!, width: Int(UIScreen.mainScreen().bounds.width))
        self.view.addSubview(wipeButton!)
    }
    
    func initManager() {
        manage = DeviceManager(view: self)
    }
    
    func initCheckedOutView() {
        checkedOutView = CheckedOutView(x: 0, y: 0, width: Int(UIScreen.mainScreen().bounds.width), height: Int(UIScreen.mainScreen().bounds.height), manager: manage!, viewController: self)
        self.view.addSubview(checkedOutView!)
    }
    
    func initHandler() {
        handler = BarcodeHandler(deviceManager: manage!)
    }
    
    func initHoldingView() {
        
        holdingView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height - 50))
        self.view.addSubview(holdingView!)
    }
    
    func initGreenBox() {
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        holdingView!.addSubview(qrCodeFrameView!)
        holdingView!.bringSubviewToFront(qrCodeFrameView!)
    }
    
    func initCamera() {
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var input: AnyObject?
        
        let error:NSError? = nil
        do { input = try AVCaptureDeviceInput(device: captureDevice) } catch _ {
            
        }
        
        if (error != nil) {
            return
        }
        
        captureSession = AVCaptureSession()
        captureSession?.addInput(input as! AVCaptureInput)
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeCode128Code]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = holdingView!.layer.bounds
        holdingView!.layer.addSublayer(videoPreviewLayer!)
        captureSession?.startRunning()
        
        if let connection =  self.videoPreviewLayer?.connection  {
            let previewLayerConnection : AVCaptureConnection = connection
            if previewLayerConnection.supportsVideoOrientation {
                previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.LandscapeRight
            }
        } else {
            print("fail")
        }
        
        
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeCode128Code {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                if(!paused) {
                    paused = true
                    handler?.handleBarcode(metadataObj.stringValue)
                    //sleep(2)
                }
            }
        }
        let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
        
        qrCodeFrameView?.frame = barCodeObject.bounds
    }
}

