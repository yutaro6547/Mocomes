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

  override func viewDidLoad() {
    super.viewDidLoad()

    let ref = FIRDatabase.database().reference()
    ref.observe(.value, with: { snapshot in
      guard let dic = snapshot.value as? Dictionary<String, AnyObject> else {
        return
      }
      guard let posts = dic["messages"] as? Dictionary<String, Dictionary<String, String>> else {
        return
      }
      self.messages = posts.values.map { dic in
        let senderId = dic["senderId"] ?? ""
        let text = dic["text"] ?? ""
        let displayName = dic["displayName"] ?? ""
        return JSQMessage(senderId: senderId,  displayName: displayName, text: text)
      }
      self.collectionView.reloadData()
    })
    //自分のsenderId, senderDisokayNameを設定
    self.senderId = "user1"
    self.senderDisplayName = "hoge"

    //吹き出しの設定
    let bubbleFactory = JSQMessagesBubbleImageFactory()
    self.incomingBubble = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    self.outgoingBubble = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())

    //アバターの設定
    self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "gudetama")!, diameter: 64)
    self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "suraime")!, diameter: 64)

    //メッセージデータの配列を初期化
    self.messages = []

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  //Sendボタンが押された時に呼ばれる
  func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {

    //新しいメッセージデータを追加する
    let message = FIRDatabase.database().reference()
    message.child("messages").childByAutoId().setValue(["senderId": senderId, "text": text, "displayName": senderDisplayName])
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
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return (self.messages?.count)!
  }

  //返信メッセージを受信する
  func receiveAutoMessage() {
    Timer.scheduledTimer(timeInterval: 1, target: self, selector: Selector(("didFinishMessageTimer:")), userInfo: nil, repeats: false)
  }

  func didFinishMessageTimer(sender: Timer) {
    let message = JSQMessage(senderId: "user2", displayName: "underscore", text: "Hello!")
    self.messages?.append(message!)
    self.finishReceivingMessage(animated: true)
  }
}
