//
//  ViewController.swift
//  Weather
//
//  Created by Anilkumar on 14/10/21.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, PassDataFromViewModelToVC {
    
    /*--------------------------------
     Outlets
     --------------------------------*/
    @IBOutlet weak var cityNameLabel : UILabel!
    @IBOutlet weak var temparatureLabel : UILabel!
    @IBOutlet weak var weatherImage : UIImageView!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /*--------------------------------
     Instance Objects
     --------------------------------*/
    
    // MARK:- View life methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
    }
    
    //MARK:- Helper method
    func initialSetup() {
        //call api and fetch data if internet connected to device
        if ConnectionManager.shared.hasConnectivity() == true {
            self.showActivityIndicator()
            let weatherService = WeatherService()
            let viewModel = WeatherViewModel(weatherService: weatherService)
            viewModel.refresh()
            viewModel.delegate = self
        } else {
            let alert = UIAlertController(title: ConstantKeys.alertNoInternetTitleKey, message: ConstantKeys.checkNetConectionTitleKey, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: ConstantKeys.okTitleKey, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //Protocol
    func SendDataToViewController(weatherInfo: Weather, error: String) {
        
        cityNameLabel.text = weatherInfo.city
        temparatureLabel.text = weatherInfo.temparature
        descriptionLabel.text = weatherInfo.description
        
        if let url = URL(string: weatherInfo.tempURL ) {
            self.hideActivityIndicator()
            weatherImage?.sd_setImage(with: url, placeholderImage: nil, options: SDWebImageOptions.highPriority, context: nil, progress: nil) {
                (downloadedImage, downloadException, cacheType, downlaodURL) in
                
                if downloadException != nil{
                    #if ENV_DEV
                    print("Error downloading the image:\(String(describing: downloadException?.localizedDescription))")
                    #endif
                }
                else{
                    #if ENV_DEV
                    print("successfully downloaded image:\(String(describing: downlaodURL?.absoluteURL))")
                    #endif
                }
            }
        }
    }
    
    /* ----------------------------------------------------
     Show activity indicator
     ------------------------------------------------------ */
    func showActivityIndicator() {
        
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
    }
    
    /* ----------------------------------------------------
     Hide activity indicator
     ------------------------------------------------------ */
    func hideActivityIndicator() {
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
}

