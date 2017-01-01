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
    let ref = FIRDatabase.database().reference()
    ref.queryLimited(toLast: 100).observe(FIRDataEventType.childAdded, with: { (snapshot) in
      let text = snapshot.value(forKey: "text")
      let sender = snapshot.value(forKey: "from")
      let name = snapshot.value(forKey: "name")
      let message = JSQMessage(senderId: sender as! String!, displayName: name as! String!, text: text as! String!)
      self.messages?.append(message!)
      self.finishReceivingMessage()
    })
  }



  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    inputToolbar!.contentView!.leftBarButtonItem = nil
    automaticallyScrollsToMostRecentMessage = true


    //自分のsenderId, senderDisokayNameを設定
    self.senderId = "user1"
    self.senderDisplayName = "hoge"

    //吹き出しの設定
    let bubbleFactory = JSQMessagesBubbleImageFactory()
    self.incomingBubble = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    self.outgoingBubble = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())

    //アバターの設定
    self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "gudetama")!, diameter: 64)
    self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "suraime")!, diameter: 64)

    //メッセージデータの配列を初期化
    self.messages = []
    setupFirebase()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  //Sendボタンが押された時に呼ばれる
  func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {

    //メッセジの送信処理を完了する(画面上にメッセージが表示される)
    self.finishReceivingMessage(animated: true)
    sendTextToDb(text: text)
  }

  func sendTextToDb(text: String) {
    let rootRef = FIRDatabase.database().reference()
    let post = ["from": senderId,
                "name": senderDisplayName,
                "text": text]
    let postRef = rootRef.childByAutoId()
    postRef.setValue(post)
  }

  //アイテムごとに参照するメッセージデータを返す
  func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
    return self.messages?[indexPath.item]
  }

  //アイテムごとのMessageBubble(背景)を返す
  func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
    let message = self.messages?[indexPath.item]
    if message?.senderId == self.senderId {
      return self.outgoingBubble
    }
    return self.incomingBubble
  }

  //アイテムごとにアバター画像を返す
  func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
    let message = self.messages?[indexPath.item]
    if message?.senderId == self.senderId {
      return self.outgoingAvatar
    }
    return self.incomingAvatar
  }

  //アイテムの総数を返す
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return (self.messages?.count)!
  }


}
