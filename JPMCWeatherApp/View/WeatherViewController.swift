import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var inputNameTextField: UITextField!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var backGroundView: UIView!
    
    var locationManager: CLLocationManager?
    var locationEnable: Bool = false
    var objWeatherListManager:WeatherListManager?
    var activityIndicator = UIActivityIndicatorView(style: .large)
    override func viewDidLoad() {
        super.viewDidLoad()
        /*intializing list manager*/
        objWeatherListManager = WeatherListManager(delegate: self)
        
        /*checking if user did last search then showing last search city/country/zipp code autofilled*/
        if let lastSearch = UserDefaults.standard.value(forKey: "lastSearch") as? String {
            inputNameTextField.text = lastSearch
        }
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        locationAccessSetUp()
    }
    
    /*set up location manager for access user location*/
    func locationAccessSetUp(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
    //MARK: Button Action
    
    @IBAction func searchWeatherAction(_ sender: Any) {
        UserDefaults.standard.setValue(inputNameTextField.text, forKey: "lastSearch")
        inputNameTextField.resignFirstResponder()
        /*if user location is enable only then user can search weather for particullar city*/
        
        if locationEnable == true {
            activityIndicator.startAnimating()
            objWeatherListManager?.fetchWeatherList(search: inputNameTextField.text ?? "")
        } else {
            self.backGroundView.isHidden = true
            let alert = UIAlertController(title: "", message: "Please turn on your location", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            alert.addAction(UIAlertAction.init(title: "Setting", style: .default, handler: { something in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            present(alert, animated: true)
        }
    }
}

//MARK: Extension

extension WeatherViewController: WeatherListManagerDelegate{
    
    /*if get succefful service response then need to show data on UI*/
    func successfullyFetchWeatherList() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.backGroundView.isHidden = false
            self.weatherConditionLabel.text = self.objWeatherListManager?.showWeatherTitle()
            self.weatherDescriptionLabel.text = self.objWeatherListManager?.showWeatherDescription()
            self.cityNameLabel.text = self.objWeatherListManager?.showCityName()
        }
        if let url = URL(string: String(format: "%@%@@2x.png", imageBaseUrl,objWeatherListManager?.showWeatherIcon() ?? "")){
            weatherIconImageView.loadWeatherImage(from: url) {
                print("image downloaded")
            }
        }
    }
    
    func failedFetchWeatherList(message:String) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
            print("error message =>",message)
        }
    }
}

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension WeatherViewController: CLLocationManagerDelegate{
    /*checking if user location is on or off based on that setting bool value*/
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            locationEnable = true
            break
        case .restricted, .denied:
            locationEnable = false
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        default:
            break
        }
    }
}
