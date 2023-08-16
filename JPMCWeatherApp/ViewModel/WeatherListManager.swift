import Foundation

protocol WeatherListManagerDelegate: AnyObject{
    func successfullyFetchWeatherList()
    func failedFetchWeatherList(message:String)
}

class WeatherListManager {
    
    weak var delegate:WeatherListManagerDelegate?
    var weatherList: Result?
    init(delegate: WeatherListManagerDelegate) {
        self.delegate = delegate
    }
    
    //MARK: webservice
    
    func fetchWeatherList(search:String){
        let url = String(format: "%@%@%@&%@", kGetWeatherInfoBaseUrl,searchName,search,appId)
        let weatherService = ApiService()
        weatherService.getWeatherList(search: url) { result in
            self.weatherList = result
            self.delegate?.successfullyFetchWeatherList()
        } onError: { errorMessage in
            self.delegate?.failedFetchWeatherList(message: errorMessage)
        }
    }
    
   //MARK: Display
    
    func showWeatherDescription() -> String{
        return  weatherList?.weather[0].description ?? ""
    }
    
    func showWeatherTitle() -> String{
        return  weatherList?.weather[0].main ?? ""
    }
    
    func showWeatherIcon() -> String{
        return weatherList?.weather[0].icon ?? "no_Image"
    }
    
    func showCityName() -> String{
        return  weatherList?.name ?? ""
    }
}
