//
//  TimelineViewController.swift
//  Bravo
//
//  Created by Unum Sarfraz on 11/24/16.
//  Copyright © 2016 BravoInc. All rights reserved.
//

import UIKit
import Parse

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PostComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set navigation bar title view
        let titleLabel = UILabel()
        titleLabel.text =
        "Reward Activity"
        titleLabel.sizeToFit()
        titleLabel.textColor = UIColor(white: 1.0, alpha: 0.5)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        navigationItem.titleView = titleLabel

        // Initialize table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")

        getPosts()
     
    }
    
    func getPosts(){
        Post.getAllPosts(success: { (posts : [PFObject]?) in
            print("--- got \(posts?.count) posts")
            self.posts = posts!
            self.tableView.reloadData()
        }, failure: { (error : Error?) in
            print("---!!! cant get posts : \(error?.localizedDescription)")
        })
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postCell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        postCell.post = posts[indexPath.row]
        
        return postCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at:indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Activity", bundle: nil)
        let commentsViewController = storyboard.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
        commentsViewController.getComments(post: posts[indexPath.row])
        show(commentsViewController, sender: self)
    }

    func postCompose(post: PFObject) {
        self.posts.insert(post, at: 0)
        tableView.reloadData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let postComposeVC = navigationController.topViewController as! PostComposeViewController
        postComposeVC.delegate = self
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
