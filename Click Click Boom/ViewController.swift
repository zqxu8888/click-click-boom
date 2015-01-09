//
//  ViewController.swift
//  Click Click Boom
//
//  Created by Jake Johnson on 1/8/15.
//  Copyright (c) 2015 Jake Johnson. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var cocked = false
    @IBOutlet weak var fireArrow: UIImageView!
    @IBOutlet weak var shakeRightArrow: UIImageView!
    @IBOutlet weak var shakeLeftArrow: UIImageView!
    
    var clickClick = AVAudioPlayer()
    var boom = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpAudio()
        var swipeUp = UISwipeGestureRecognizer(target: self, action: Selector("swiped:"))
        swipeUp.direction = .Up
        self.view.addGestureRecognizer(swipeUp)
        
        self.hideImageViews(true, views: [self.fireArrow])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpAudio()
    {
        var clickLocation = NSString(string: NSBundle.mainBundle().pathForResource("clickclick", ofType: "mp3")!)
        var clickURL = NSURL(fileURLWithPath: clickLocation)!
        var clickError : NSError?
        
        var boomLocation = NSString(string: NSBundle.mainBundle().pathForResource("boom", ofType: "mp3")!)
        var boomURL = NSURL(fileURLWithPath: boomLocation)!
        var boomError : NSError?
        
        self.clickClick = AVAudioPlayer(contentsOfURL: clickURL, error: &clickError)
        self.boom = AVAudioPlayer(contentsOfURL: boomURL, error: &boomError)
    }
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent)
    {
        if event.subtype == UIEventSubtype.MotionShake {
            self.cocked = true
            self.clickClick.play()
            self.hideImageViews(false, views: [self.fireArrow])
            self.shakeRightArrow.alpha = 0
            self.shakeLeftArrow.alpha = 0
        }
    }
    
    func swiped(gesture: UIGestureRecognizer)
    {
        if (self.cocked) {
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.Up:
                    self.fireArrow.alpha = 0
                    self.boom.play()
                    self.cocked = false
                    self.hideImageViews(false, views: [self.shakeRightArrow, self.shakeLeftArrow])
                default:
                    break
                }
            }
        }
    }
    
    func hideImageViews(visibility: Bool, views: Array<UIImageView>)
    {
        for view in views {
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                if (visibility) {
                    view.alpha = 0
                    println("Hiding")
                } else {
                    view.alpha = 100
                    println("Showing")
                }
            })
        }
    }
    
}

