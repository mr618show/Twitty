//
//  TwitterClient.swift
//  Tweeter
//
//  Created by Rui Mao on 4/14/17.
//  Copyright © 2017 Rui Mao. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterbaseURL = NSURL(string: "https://api.twitter.com/")
let twitterConsumerKey: String = "EVsXgH8SH0m35ctoPFkLfLRbo"
let twitterConsumerSecret: String = "LazYtWibDQAfBRxc8TsfbS0SfGKDL62icKu4yvs7kwP8T4sVdd"

class TwitterClient: BDBOAuth1SessionManager {

    
    static let sharedInstance = TwitterClient(baseURL: twitterbaseURL as URL!, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
  
    func login(success: @escaping ()->(), failure: @escaping (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        let client = TwitterClient.sharedInstance
        
        client?.deauthorize()
        client?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "mytwitterdemo://oauth") as URL!, scope: nil, success: {
            (requestToken:BDBOAuth1Credential?) -> Void in
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }, failure: {
            (error: Error?) -> Void in
            print("error: \(error?.localizedDescription) ")
            self.loginFailure?(error as! NSError)
        })
    }
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken:  requestToken, success: { (accessToken:BDBOAuth1Credential?) -> Void in
            self.currentAccount(success: { (user: User) -> () in
                    User.currentUser = user
                    self.loginSuccess?()
            }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
            })
        }, failure: {
            (error: Error?) -> Void in
            print ("error: \(error?.localizedDescription)")
            self.loginFailure?(error as! NSError)
        }
        )
    }
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()) {
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
        
        }, failure: { (task:URLSessionDataTask?, error: Error) in
            failure(error as NSError)
            
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (NSError) -> ()){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            //print ("account: \(response)")
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            //print ("name: \(user.name!)")
            //print ("screenname: \(user.screenname!)")
            //print ("profile url: \(user.profileUrl!)")
            //print ("description:  \(user.tagline!)")
        }, failure: { (task: URLSessionDataTask?, error:Error) -> Void in
            failure (error as NSError)
        })
    }

}