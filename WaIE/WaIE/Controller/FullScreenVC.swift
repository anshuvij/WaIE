//
//  FullScreenVC.swift
//  WaIE
//
//  Created by Anshu Vij on 18/03/23.
//

import UIKit

class FullScreenVC: UIViewController {

    
    @IBOutlet weak var fullScreenImage: UIImageView!
    
    var url : URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fullScreenImage.layer.cornerRadius = 4.0
        self.fullScreenImage.clipsToBounds = true
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
        
        if let url = url {
                DispatchQueue.main.async {
                    self.fullScreenImage.loadImage(from: url)
                }
            
        }
    }

}
