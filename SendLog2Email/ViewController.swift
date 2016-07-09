//
//  ViewController.swift
//  SendLog2Email
//
//  Created by doriswu on 2016/7/9.
//  Copyright © 2016年 doriswu. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtLog: UITextView!
    
    var path = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // create file
        let file = "log.txt"
        
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "asia/taipei")
        let correctDate = dateFormatter.stringFromDate(date)
        
        var txt  = "log Recard: \(correctDate)"
        
        
        /*
        iPhone會為每一個應用程序生成一個私有目錄，這個目錄位於：
        /Users/XXX/Library/Application Support/iPhone Simulator/User/Applications下，
        並隨即生成一個數字字母串作為目錄名，在每一次應用程序啟動時，這個字母數字串都是不同於上一次。
        */
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            
            //.first 取得第一個檔案（此次執行的專案記錄位置）
            // 建立Log檔路徑
            path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file)
            txt = "\(txt)\n\(path)"
            
            // 寫入
            do {
                try txt.writeToURL(path, atomically: true, encoding: NSUTF8StringEncoding)
            } catch {
                print("寫入失敗")
            }
            
            // 讀取
            do {
                let str = try NSString (contentsOfURL: path, encoding: NSUTF8StringEncoding)
                txtLog.text = "\(str)"
            } catch {
                print("讀出失敗")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func actSend(sender: AnyObject) {
        if( MFMailComposeViewController.canSendMail() ) {
            print("Can send email.")
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            //Set the subject and message of the email
            mailComposer.setToRecipients([txtEmail.text!])
            mailComposer.setSubject("App Log")
            mailComposer.setMessageBody("FYI", isHTML: false)
            
            if let fileData = NSData(contentsOfURL: path) {
                mailComposer.addAttachmentData(fileData, mimeType: "text/plain", fileName: "Log")
            }
            self.presentViewController(mailComposer, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

