//
//  ViewController.swift
//  ColorsGame
//
//  Created by Alex Greene on 2/16/15.
//  Copyright (c) 2015 Alex Greene. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate,
MCSessionDelegate {
    
    let serviceType = "LCOC-Chat"
    
    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var peerID: MCPeerID!
    
    
    @IBOutlet var colorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        
        self.browser = MCBrowserViewController(serviceType:serviceType,
            session:self.session)
        
        self.browser.delegate = self;
        
        self.assistant = MCAdvertiserAssistant(serviceType:serviceType,
            discoveryInfo:nil, session:self.session)
        
        self.assistant.start()
        
    }
    
    
    func updateColor(isYellow : Int, fromPeer peerID: MCPeerID) {
        
        if isYellow == 1 {
            self.colorView.backgroundColor = UIColor.blueColor()
        }
        else {
            self.colorView.backgroundColor = UIColor.yellowColor()
        }
        
    }
    
    
    @IBAction func sendColor(sender: AnyObject) {
        
        var error : NSError?
        
        var isYellow: Int
        
        if self.colorView.backgroundColor == UIColor.yellowColor() {
            isYellow = 1
        }
        else {
            isYellow = 0
        }
        
        self.session.sendData(NSData(bytes:&isYellow, length: 1), toPeers: self.session.connectedPeers,
            withMode: MCSessionSendDataMode.Unreliable, error: &error)
        
        if error != nil {
            print("Error sending data: \(error?.localizedDescription)")
        }
        
        self.updateColor(isYellow, fromPeer: self.peerID)
    }
    
    
    @IBAction func openBrowser(sender: AnyObject) {
        
        self.presentViewController(self.browser, animated: true, completion: nil)
    }
    
    
    func browserViewControllerDidFinish(
        browserViewController: MCBrowserViewController!)  {
            
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(
        browserViewController: MCBrowserViewController!)  {
            
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!,
        fromPeer peerID: MCPeerID!)  {
            
            var temp: Int = 0
            data.getBytes(&temp, length: 1)
            dispatch_async(dispatch_get_main_queue()) {
                
                self.updateColor(temp, fromPeer: peerID)
            }
    }
    
    func session(session: MCSession!,
        didStartReceivingResourceWithName resourceName: String!,
        fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!)  {
    }
    
    func session(session: MCSession!,
        didFinishReceivingResourceWithName resourceName: String!,
        fromPeer peerID: MCPeerID!,
        atURL localURL: NSURL!, withError error: NSError!)  {
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!,
        withName streamName: String!, fromPeer peerID: MCPeerID!)  {
    }
    
    func session(session: MCSession!, peer peerID: MCPeerID!,
        didChangeState state: MCSessionState)  {
            
    }
    
    
    
}
