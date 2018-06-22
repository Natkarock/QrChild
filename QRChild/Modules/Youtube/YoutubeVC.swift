//
//  YoutubeVC.swift
//  QRChild
//
//  Created by Karapats on 18/06/ 15.
//  Copyright © 2018 Karapats. All rights reserved.
//

import UIKit
import YouTubePlayer
import BubbleTransition

class YoutubeVC: UIViewController {
    
    var youtubeId:String? = nil
    var prevVC: UIViewController? = nil
    
    @IBOutlet var youtubeView:YouTubePlayerView!
    @IBOutlet var btnClose: UIButton!
    var indicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
        loadVideo(by: youtubeId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*let pastViewController = self.presentingViewController as? MainVC
        pastViewController?.dismiss(animated: false, completion: {})*/
    }
    

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) -> Void in
            self.indicator = self.setupActivityIndicator()
        }, completion: { (context) -> Void in
            
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func initVC(){
        //transitioningDelegate = self
        btnClose.layer.cornerRadius = 20
        youtubeView.playerVars = [
            "playsinline": "1",
            "controls": "1",
            "showinfo": "0",
            "color": "black"
            ] as YouTubePlayerView.YouTubePlayerParameters
        youtubeView.delegate = self
        youtubeView.isHidden = true
        indicator = setupActivityIndicator()
        indicator.color = UIColor.white
        start(indicator: indicator)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadVideo(by id:String?){
        if let `id` = id {
            if let `idSubstring` = id.substring(by: youtubeIdRegexp){
                youtubeView.loadVideoID(idSubstring)
            }else {
                let myVideoURL = URL(string: id)
                if let `myVideoURL` = myVideoURL {
                    youtubeView.loadVideoURL(myVideoURL)
                }
            }
        }else {
          stop(indicator: indicator)
        }
    }
    
    
    @IBAction func close(sender: Any){
        dismiss(animated: true, completion: {
        })
    }
}


extension YoutubeVC : YouTubePlayerDelegate {
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        stop(indicator: indicator)
        youtubeView.isHidden = false
        youtubeView.play()
    }
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        print("player state changed to: \(playerState.rawValue)")
    }
    
    
    func playerQualityChanged(_ videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {
        print("playback quality changed to: \(playbackQuality.rawValue)")
    }
}


extension YoutubeVC : UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = BubbleTransition()
        transition.transitionMode = .present
        transition.startingPoint = self.view.center
        transition.duration = 2.0
        transition.bubbleColor = .black
        return transition
    }
}
