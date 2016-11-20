//
//  TeamCreationViewController.swift
//  Bravo
//
//  Created by Unum Sarfraz on 11/12/16.
//  Copyright © 2016 BravoInc. All rights reserved.
//

import UIKit

class TeamCreationViewController: UIViewController {

    @IBOutlet weak var teamNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCreateTapped(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "TeamCreation", bundle: nil)
        
        Team.teamExists(teamName: teamNameTextField.text!, success: {
            Team.createTeam(teamName: self.teamNameTextField.text!, success: {
                print("--- team created : \(self.teamNameTextField.text!)")
                let rewardsVC = storyboard.instantiateViewController(withIdentifier: "RewardsViewController")
                self.show(rewardsVC, sender: self)
            })

        }, failure: {
            self.showTeamErrorDialog(teamName: self.teamNameTextField.text!)
            self.teamNameTextField.text = ""
            

        })
    }

    func showTeamErrorDialog(teamName: String) {
        let message = "Team \(teamName) already exists."
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        

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
