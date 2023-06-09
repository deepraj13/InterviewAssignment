//
//  UserDetailViewController.swift
//  InterviewAssignment
//
//  Created by Deepraj Chowrasia on 09/06/23.
//

import UIKit
import SDWebImage

@objc class UserDetailViewController: UIViewController {
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var emailOutlet: UILabel!
    @IBOutlet weak var dateJoined: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @objc var user: User?
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var postcode: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var state: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupUI()
        setupNavigationBar()
       

        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        let radians = CGFloat(-45.0 * Double.pi / 180.0)
        ageLabel.transform = CGAffineTransform(rotationAngle: radians)
        ageLabel.layer.borderWidth = 1.0
        ageLabel.layer.borderColor = UIColor.yellow.cgColor
    }
    
    func setupView(){
        if let user = user {
            self.title = user.name
            if let age = user.age {
                self.ageLabel.text = "\(age.stringValue)"
            } else {
                self.ageLabel.text = nil
            }
            let dobText = "DOB: \(user.dob ?? "DOB : N/A")"
                dob.text = dobText
            let emailText = "Email: \(user.email ?? "Email : N/A")"
                emailOutlet.text = emailText
                
                // Set Date Joined
            let dateJoinedText = "Date Joined: \(user.registrationDate ?? "Date Joined:N/A")"
                dateJoined.text = dateJoinedText
                
                // Set City
            let cityText = "city: \(user.city ?? "city: N/A")"
                city.text = cityText
                
                // Set State
            let stateText = "state: \(user.state ?? "state: N/A")"
                state.text = stateText
                
                // Set Country
            let countryText = "country: \(user.country ?? "country: N/A")"
                country.text = countryText
                
                // Set Postcode
            let postcodeText = "postcode: \(user.postcode ?? "postcode : N/A")"
                postcode.text = postcodeText

            // Set profile image using SDWebImage
            if let profileImageUrl = user.pictureURL, let url = URL(string: profileImageUrl) {
                profileImage.sd_setImage(with: url)
            }
        }
    }

    func setupNavigationBar() {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.lightGray
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }

       
    }
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

//}
