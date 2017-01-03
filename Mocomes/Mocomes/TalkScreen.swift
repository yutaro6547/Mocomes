//
//  TalkScreen.swift
//  Mocomes
//
//  Created by ytzuki on 2016/12/30.
//  Copyright © 2016年 ytzuki. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

class TalkScreen: JSQMessagesViewController {

  var messages: [JSQMessage]?
  var incomingBubble: JSQMessagesBubbleImage!
  var outgoingBubble: JSQMessagesBubbleImage!
  var incomingAvatar: JSQMessagesAvatarImage!
  var outgoingAvatar: JSQMessagesAvatarImage!

  func setupFirebase() {
    let ref = FIRDatabase.database().reference(fromURL: "https://mocomes-1594c.firebaseio.com/")
    ref.queryLimited(toLast: 25).observe(FIRDataEventType.childAdded, with: { (snapshot) in
      let snapshotValue = snapshot.value as! NSDictionary
      let text = snapshotValue["text"] as! String
      print("\(text)")
      let sender = snapshotValue["from"] as! String
      print("\(sender)")
      let name = snapshotValue["name"] as! String
      print("\(name)")
      let message = JSQMessage(senderId: sender, displayName: name, text: text)
      print("\(message)")
      self.messages?.append(message!)
      self.finishReceivingMessage()
    })
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    inputToolbar!.contentView!.leftBarButtonItem = nil
    automaticallyScrollsToMostRecentMessage = true

    self.senderId = "user1"
    self.senderDisplayName = "hoge"

    let bubbleFactory = JSQMessagesBubbleImageFactory()
    self.incomingBubble = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    self.outgoingBubble = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "gudetama")!, diameter: 64)
    self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "suraime")!, diameter: 64)

    self.messages = []
    setupFirebase()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
    self.finishReceivingMessage(animated: true)
    sendTextToDb(text: text)
    self.finishSendingMessage()
  }

  func sendTextToDb(text: String) {
    let rootRef = FIRDatabase.database().reference()
    let post:Dictionary<String, Any>? = ["from": senderId,
                                         "name": senderDisplayName,
                                         "text": text]
    let postRef = rootRef.childByAutoId()
    postRef.setValue(post)
  }

  func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
    return self.messages?[indexPath.item]
  }

  func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
    let message = self.messages?[indexPath.item]
    if message?.senderId == self.senderId {
      return self.outgoingBubble
    }
    return self.incomingBubble
  }

  func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
    let message = self.messages?[indexPath.item]
    if message?.senderId == self.senderId {
      return self.outgoingAvatar
    }
    return self.incomingAvatar
  }

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return (self.messages?.count)!
  }
}
