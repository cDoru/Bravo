//
//  RewardsViewController.swift
//  Bravo
//
//  Created by Unum Sarfraz on 11/13/16.
//  Copyright © 2016 BravoInc. All rights reserved.
//

import UIKit
import Parse


@objc protocol RewardsViewControllerDelegate {
    @objc optional func saveRewards(rewards: [PFObject])
}

class RewardsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RewardCreationViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var defaultRewards = [PFObject]()
    var currentTeam : PFObject!
    weak var delegate: RewardsViewControllerDelegate?
    var teamExists = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set default rewards
        let rewards = [("1 Day Off", 2000), ("Free lunch", 200), ("Concert Ticket", 1000), ("Movie Ticket", 300)]
        
        for reward in rewards {
            let newReward = Reward.createReward(team : currentTeam, rewardName : reward.0, rewardPoints: reward.1, isActive: true)
            defaultRewards.append(newReward)
        }
        // Set navigation bar title view
        
        //let titleLabel = UILabel()
        //titleLabel.text = "Pick Rewards"
        //titleLabel.sizeToFit()
        //navigationItem.titleView = titleLabel
        
        //self.navigationItem.setHidesBackButton(true, animated:false);
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onSubmit(_:)))



        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.tableFooterView = UIView()

        tableView.register(UINib(nibName: "RewardCell", bundle: nil), forCellReuseIdentifier: "RewardCell")
        tableView.register(UINib(nibName: "MoreRewardsCell", bundle: nil), forCellReuseIdentifier: "MoreRewardsCell")
        
        tableView.reloadData()

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultRewards.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row < defaultRewards.count) {
            let rewardCell = tableView.dequeueReusableCell(withIdentifier: "RewardCell") as! RewardCell
            rewardCell.isChecked = defaultRewards[indexPath.row]["isActive"]! as! Bool
            rewardCell.reward = defaultRewards[indexPath.row]
            
            return rewardCell
        } else {
            let moreRewardsCell = tableView.dequeueReusableCell(withIdentifier: "MoreRewardsCell") as! MoreRewardsCell
            return moreRewardsCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath.row < defaultRewards.count) {
            defaultRewards[indexPath.row]["isActive"] = !(defaultRewards[indexPath.row]["isActive"]! as! Bool)
            tableView.reloadData()
        } else {
            let storyboard = UIStoryboard(name: "TeamCreation", bundle: nil)
            
            let rewardCreationNavController = storyboard.instantiateViewController(withIdentifier: "RewardsCreationNavigationController") as! UINavigationController
            
            let rewardVC = storyboard.instantiateViewController(withIdentifier: "RewardCreationViewController") as! RewardCreationViewController
            rewardVC.currentTeam = self.currentTeam
            rewardVC.delegate = self
            rewardCreationNavController.setViewControllers([rewardVC], animated: true)
            self.present(rewardCreationNavController, animated: true, completion: nil)
        }
    }
    
    func onSubmit(_ sender: UIBarButtonItem) {
        let totalRewards = defaultRewards.count - 1
        for i in (0...totalRewards).reversed() {
            if !(defaultRewards[i]["isActive"]! as! Bool) {
                defaultRewards.remove(at: i)
            }
        }
        
        if teamExists {
            self.delegate?.saveRewards?(rewards: self.defaultRewards)
            self.navigationController?.popViewController(animated: true)
       } else {
            displayMessage(title: "Bravo!", subTitle: "You have successfully set up a new team!", duration: 3.0, showCloseButton: false, messageStyle: .success)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
                self.performSegue(withIdentifier: "unwindToTeamConfig", sender: self)
                self.delegate?.saveRewards?(rewards: self.defaultRewards)
                
            }
        }

    }

    func onBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func rewardCreationViewController(rewardCreationViewController: RewardCreationViewController, reward: PFObject) {
        defaultRewards.append(reward)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
