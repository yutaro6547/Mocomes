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
  let ref = FIRDatabase.database().reference()

  func setupFirebase() {
    ref.queryLimited(toLast: 100).observe(FIRDataEventType.childAdded, with: { (snapshot) in
      let snapshotValue = snapshot.value as! NSDictionary
      let text = snapshotValue["text"] as! String
      let sender = snapshotValue["from"] as! String
      let name = snapshotValue["name"] as! String
      let message = JSQMessage(senderId: sender, displayName: name, text: text)
      self.messages?.append(message!)
      self.finishReceivingMessage()
    })
  }

  override func viewDidLoad() {
    super.viewDidLoad()
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
  }

  //Sendボタンが押された時に呼ばれる
  override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
    _ = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
    //ex: self.messages.append(message!)
    self.finishSendingMessage()
    //メッセージの送信処理を完了する(画面上にメッセージが表示される)
    self.finishReceivingMessage(animated: true)
    sendTextToDb(text: text)
  }
  
  func sendTextToDb(text: String) {
    self.ref.child((FIRAuth.auth()?.currentUser?.uid)!).childByAutoId().setValue(["user": (FIRAuth.auth()?.currentUser?.uid)!,"text": text, "date": FIRServerValue.timestamp()])
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
