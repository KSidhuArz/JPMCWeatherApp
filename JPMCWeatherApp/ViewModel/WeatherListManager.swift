import Foundation

protocol WeatherListManagerDelegate: AnyObject{
    func successfullyFetchWeatherList()
    func failedFetchWeatherList(message:String)
}

class WeatherListManager {
    
    weak var delegate:WeatherListManagerDelegate?
    var weatherList: ResultWeather?
    init(delegate: WeatherListManagerDelegate) {
        self.delegate = delegate
    }
    
    //MARK: webservice
    
    /// in this method calling get weather service
    /// - Parameter search: we are passing city or zipcode
    func fetchWeatherList(search:String){
        let url = String(format: "%@%@%@&%@", kGetWeatherInfoBaseUrl,searchName,search,appId)
        let weatherService = ApiService()
        weatherService.getWeatherList(search: url) { result in
            switch result {
            case .success(let data):
                self.weatherList = data
                self.delegate?.successfullyFetchWeatherList()
            case .failure(let error):
                error == .cityNotFound ? self.delegate?.failedFetchWeatherList(message: "City not found") : self.delegate?.failedFetchWeatherList(message: "Time out")
            }
        }
    }
    
   //MARK: Display
    
    /// showing wether description
    /// - Returns: string
    func showWeatherDescription() -> String{
        return  weatherList?.weather[0].description ?? ""
    }
    
    /// showing weather title
    /// - Returns: string
    func showWeatherTitle() -> String{
        return  weatherList?.weather[0].main ?? ""
    }
    
    /// showing weather icon
    /// - Returns: string
    func showWeatherIcon() -> String{
        return weatherList?.weather[0].icon ?? "no_Image"
    }
    
    /// showing city name
    /// - Returns: string
    func showCityName() -> String{
        return  weatherList?.name ?? ""
    }
}
