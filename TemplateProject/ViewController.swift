//
//  ViewController.swift
//  Template Project
//
//  Created by Benjamin Encz on 5/15/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let title = NSUserDefaults(suiteName: "group.mukatay.TestShareDefaults")!.objectForKey("webTitle") as? String, let url = NSUserDefaults(suiteName: "group.mukatay.TestShareDefaults")!.objectForKey("webURL") as? String {
            self.titleLabel.text = title
            println("Title: \(title)")
            self.urlLabel.text = url
            println("URL: \(url)")
            webView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
            webView.delegate = self
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController : UIWebViewDelegate {
//        func webViewDidFinishLoad(webView: UIWebView) {
//            var href = webView.stringByEvaluatingJavaScriptFromString("document.images[0].src")!
//            println(href)
//            let url = NSURL(string: href)
//            var err: NSError?
//            var imageData :NSData = NSData.dataWithContentsOfURL(url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!
//            var bgImage = UIImage(data:imageData)
//            self.imageView.image = bgImage
//        }
}


