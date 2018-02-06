//
//  HomeViewController.swift
//  Instagram
//
//  Created by Samuel Carbone on 2/4/18.
//  Copyright © 2018 Samuel Carbone. All rights reserved.
//

import UIKit
import Firebase
class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    var posts : [DocumentSnapshot] = []
    let postsRef = Firestore.firestore().collection("posts").limit(to: 20).order(by: "time", descending: true)
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.addSubview(refreshControl)
        self.refreshControl.addTarget(self, action: #selector(refreshPosts(_:)), for: .valueChanged)
        loadData()
    }
    @objc func refreshPosts(_ sender: Any) {
        loadData()
        refreshControl.endRefreshing()
    }
    func loadData() {
        postsRef.getDocuments { (snapshot, error) in
            if snapshot != nil {
                var array : [DocumentSnapshot] = []
                for document in snapshot!.documents{
                    array.append(document)
                }
                self.posts = array
                self.tableView.reloadData()
            }
            else{
                //Document doesn't exist
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = posts[indexPath.row].data()
        cell.selectionStyle = .none
        if let image64 = post["image"] as? String {
            let imageDecoded:NSData = NSData(base64Encoded: image64, options: NSData.Base64DecodingOptions(rawValue: 0))!
            let image:UIImage = UIImage(data: imageDecoded as Data)!
            cell.postImageView.image = image
        }
        cell.postCaption.text = post["caption"] as? String
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "postDetailsSegue"){
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell){
                let post = posts[indexPath.row].data()
                let postDetailController = segue.destination as! PostDetailViewController
                postDetailController.postData = post
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "loginPage") as UIViewController
            present(vc, animated: true, completion: nil)
            self.navigationController!.viewControllers.removeAll()
        } catch{
            print("There was an error.")
        }
    }
    @IBAction func addPost(_ sender: UIButton) {
        self.performSegue(withIdentifier: "addPostSegue", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
