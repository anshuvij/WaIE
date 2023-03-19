//
//  MainViewController.swift
//  WaIE
//
//  Created by Anshu Vij on 18/03/23.
//

import UIKit

class MainViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var informationView: UITextView!
    @IBOutlet weak var titleText: UILabel!
    var astronomyViewModel: AstronomyViewModel?
    var imageUrl : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Reachability.isConnectedToNetwork() {
            astronomyViewModel?.requestTodayImages(isOnlineMode: true)
        }
        else {
            astronomyViewModel?.requestTodayImages(isOnlineMode: false)
        }
        
    }
    
   private func setupUI() {
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(loadFullImage))
        imageView.addGestureRecognizer(tapGest)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.imageView.isUserInteractionEnabled = true
        self.informationView.isEditable = false
        
        self.imageView.layer.cornerRadius = 4.0
        self.imageView.clipsToBounds = true
        
        handleCallbacks()
     
    }
    
    private func handleCallbacks() {
        
        astronomyViewModel = AstronomyViewModel()
        
        astronomyViewModel?.reloadOnData = { [weak self] in
            
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.displayImageData()
            }
        }
        astronomyViewModel?.networkOffline = { [weak self] result in
            
            var message = ""
            guard let self = self else { return }
            switch result {
            case .NoData, .DecodingError, .BadURL :
                message = "We are not connected to the internet, showing you the last image we have"
                
            case .Offline :
                message = "Please check internet connectivity"
            }
            let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func displayImageData() {
        let astronomyDataViewModel = astronomyViewModel?.astronomyDataViewModel
        if let astronomyDataViewModel = astronomyDataViewModel {
            self.titleText.text = astronomyDataViewModel.title
            self.informationView.text = astronomyDataViewModel.explanation
            if let url = URL(string: astronomyDataViewModel.url) {
                self.imageUrl = url
               self.imageView.loadImage(from: url)
                
            }
        }
    }
    
    @objc private func loadFullImage() {
        let vc = FullScreenVC()
        vc.url = imageUrl
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

