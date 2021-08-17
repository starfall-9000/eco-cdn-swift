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
    var player: AVPlayer? = nil
    var layer: AVPlayerLayer? = nil
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layer?.frame = CGRect(origin: .zero, size: container.frame.size)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupPlayer()
    }
    
    private func setupPlayer() {
        guard let orginalUrl = URL(string: "https://mid-cdn.fptplay.net/hda1/vtv1hd_hls.smil/playlist.m3u8")
        else { return }
        let parsedUrl = SWCP2pEngine.sharedInstance().parse(streamURL: orginalUrl)
        player = AVPlayer.init(url: parsedUrl)
        layer = AVPlayerLayer(player: player)
        layer?.videoGravity = .resizeAspect
        if let layer = layer {
            container.layer.addSublayer(layer)
        }
        player?.play()
    }
}

