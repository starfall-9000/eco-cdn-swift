//
//  ViewController.swift
//  EcoCDN
//
//  Created by An Binh on 17/08/2021.
//

import UIKit
import AVKit
import SwarmCloudSDK

class ViewController: UIViewController {
    @IBOutlet weak var container: UIView!
    var playerItem: AVPlayerItem? = nil
    
    var player: AVPlayer? = AVPlayer()
    var layer: AVPlayerLayer? = nil
    
    var startTime: TimeInterval = 0
    var currentTime: TimeInterval { return Date().timeIntervalSince1970 }
    var excuteTime: TimeInterval { return currentTime - startTime }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layer?.frame = CGRect(origin: .zero, size: container.frame.size)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startTime = currentTime
        setupPlayer()
        prepareToPlay()
        registerObserve()
    }
    
    private func setupPlayer() {
        layer = AVPlayerLayer(player: player)
        layer?.videoGravity = .resizeAspect
        if let layer = layer {
            container.layer.addSublayer(layer)
        }
    }
    
    func prepareToPlay() {
        print("DEBUG:: prepare to play, start time: \(startTime)")
        guard let originUrl = URL(string: "https://mid-cdn.fptplay.net/hda1/vtv1hd_hls.smil/playlist.m3u8")
        else { return }
        setupSDK()
        let parsedUrl = SWCP2pEngine.sharedInstance().parse(streamURL: originUrl)
        let asset = AVURLAsset(url: parsedUrl)
        playerItem = AVPlayerItem(asset: asset)
        player?.replaceCurrentItem(with: playerItem)
        player?.play()
    }
    
    private func setupSDK() {
        let config = SWCP2pConfig.defaultConfiguration()
        config.logLevel = SWCLogLevel.debug
        SWCP2pEngine.sharedInstance().start(token: "luK3-_tMR", p2pConfig: config)
    }
    
    private func registerObserve() {
        playerItem?.addObserver(self,
                                forKeyPath: #keyPath(AVPlayerItem.status),
                                options: [.old, .new],
                                context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        print("DEBUG:: observeValue \(keyPath ?? "non-key-path"), excute time: \(excuteTime)")
        if keyPath == #keyPath(AVPlayerItem.status) {
            let newStatus: AVPlayerItem.Status
            
            // Get the status change from the change dictionary
            if let statusNumber = change?[.newKey] as? NSNumber,
               let status = AVPlayerItem.Status(rawValue: statusNumber.intValue) {
                newStatus = status
            } else {
                newStatus = .unknown
            }
            
            // Switch over the status
            switch newStatus {
            case .readyToPlay:
                print("DEBUG:: ready to play, excute time: \(excuteTime)")
            case .failed:
                print("DEBUG:: failed")
            case .unknown:
                print("DEBUG:: unknown")
            @unknown default:
                print("DEBUG:: default")
            }
        }
    }
}

