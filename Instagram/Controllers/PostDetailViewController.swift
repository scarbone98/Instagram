//
//  PostDetailViewController.swift
//  Instagram
//
//  Created by Samuel Carbone on 2/5/18.
//  Copyright © 2018 Samuel Carbone. All rights reserved.
//

import UIKit
import Firebase
class PostDetailViewController: UIViewController {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var time: UILabel!
    
    var postData:[String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image64 = postData["image"] as? String
        let imageDecoded:NSData = NSData(base64Encoded: image64!, options: NSData.Base64DecodingOptions(rawValue: 0))!
        let image:UIImage = UIImage(data: imageDecoded as Data)!
        postImage.image = image
        caption.text = postData["caption"] as? String
        if let date = postData["time"] as? Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            let strMonth = dateFormatter.string(from: date)
            let calendar = Calendar.current
            let day = calendar.component(.day, from: date)
            let year = calendar.component(.year, from: date)
            time.text = "\(strMonth) \(day), \(year)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
