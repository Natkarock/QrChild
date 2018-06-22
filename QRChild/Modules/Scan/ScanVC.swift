//
//  ScanVC.swift
//  QRChild
//
//  Created by Karapats on 18/06/ 15.
//  Copyright © 2018 Karapats. All rights reserved.
//

import UIKit
import AVFoundation


class ScanVC: UIViewController {
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var btnClose: UIButton!
    
    
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var qrImageView: UIImageView?
    
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.qr]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) -> Void in
            self.videoPreviewLayer?.connection?.videoOrientation = self.transformOrientation(orientation:
                UIInterfaceOrientation(rawValue: UIApplication.shared.statusBarOrientation.rawValue)!)
            self.videoPreviewLayer?.frame.size = self.view.frame.size
        }, completion: { (context) -> Void in
            
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.videoPreviewLayer?.frame.size = self.view.frame.size
    }
    
    func initVC(){
        btnClose.layer.cornerRadius = 20
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authorizationStatus {
        case .notDetermined:
            print("notDetermined")
            AVCaptureDevice.requestAccess(for: AVMediaType.video,
                                          completionHandler: { (granted:Bool) -> Void in
                                            if granted {
                                                self.initQRView()
                                            }
                                            else {
                                                self.messageLabel.text = cameraAccessDeniedString                                            }
            })
        case .authorized:  print("authorized");
        self.initQRView()
        case .denied, .restricted: print ("restricted")
        self.messageLabel.text = cameraAccessDeniedString
        }
    }
    
    
    
    func initQRView (){
        // Get the back-facing camera for capturing videos
        self.messageLabel.text = noQrString
        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
        guard let captureDevice = device else {
            print("Failed to get the camera device")
            messageLabel.text = noCameraString
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        DispatchQueue.main.async(execute: { () -> Void in
            self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            self.videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.videoPreviewLayer?.connection?.videoOrientation = self.transformOrientation(orientation:
                UIInterfaceOrientation(rawValue: UIApplication.shared.statusBarOrientation.rawValue)!)
            self.self.videoPreviewLayer?.frame.size = self.view.frame.size
            self.view.clipsToBounds = true
            self.view.layer.addSublayer(self.videoPreviewLayer!)})
        
        // Start video capture.
        captureSession.startRunning()
        
        // Move the message label and top bar to the front
        view.bringSubview(toFront: messageLabel)
        view.bringSubview(toFront: btnClose)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.white.cgColor
            qrCodeFrameView.layer.borderWidth = 4
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }
    
    
    
    func transformOrientation(orientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation {
        switch orientation {
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func youtubeBtnAction(sender: Any){
        setQRCode(value: "https://www.youtube.com/watch?v=xgDZ7iKC-rk")
    }
    
    
    func showYoutubeVC(youtubeId:String?){
        let youtubeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "YoutubeVC") as? YoutubeVC
        if let `youtubeId` = youtubeId {
            youtubeVC?.youtubeId = youtubeId
        }
        if let `youtubeVC` = youtubeVC {
            youtubeVC.transitioningDelegate = self
            youtubeVC.prevVC = self
            let pastViewController = self.presentingViewController as? MainVC
            dismiss(animated: false, completion: {
                pastViewController?.present(youtubeVC, animated: true , completion: {})
            })
            //self.present(youtubeVC, animated: true , completion: {})
        }
    }
    
    
    @IBAction func close(sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    
    
}

extension ScanVC: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        
        if metadataObjects.count == 0 {
            self.qrCodeFrameView?.frame = CGRect.zero
            self.messageLabel.text = noQrString
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            if metadataObj.stringValue != nil {
                if let value = metadataObj.stringValue {
                    setQRCode(value:value)
                }
            }
        }
    }
    
    func setQRCode(value:String){
        let youtubeId:String? = value
        messageLabel.text = value
        if let `youtubeId` = youtubeId{
            if let id = youtubeId.substring(by: youtubeRegexp){
                print(id)
                showYoutubeVC(youtubeId: id)
            }else {
                messageLabel.text = wrongQrFormatString
            }
        }
    }
    
}


extension ScanVC: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return QrCodeRotateAnimator(duration: 2.0, image: #imageLiteral(resourceName: "qr_yotube"),
                                    backgroundColor: UIColor().colorFromHexString("2E7384"),
                                    imgSize: 200)
    }
}




