//
//  TestVC.swift
//  Location-Based-Coupons
//
//  Created by Robert Schroeder on 4/19/24.
//

import UIKit
import SwiftUI

class TestVC: UIViewController {
    
    let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemBackground
        configureButton()
    }
    
    func configureButton(){
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.systemBlue
        button.setTitle("NextVC", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16 , weight: UIFont.Weight.bold)
        button.addTarget(self, action: #selector(didTap), for: UIControl.Event.touchUpInside)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 100)
        
        
        ])
        
        
        
    }
    
    @objc func didTap(){
        
        let nextVC = ProfileView()
        
        let hostingController = UIHostingController(rootView: nextVC)
        
        navigationController?.pushViewController(hostingController, animated: true)
        
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
