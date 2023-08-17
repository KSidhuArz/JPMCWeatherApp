import Foundation

enum weatherServiceError: Error{
    case cityNotFound
    case timeOut
}

class ApiService: NSObject {
    
    
    /// calling a web service
    /// - Parameters:
    ///   - search: passing url string
    ///   - completion: returning success and failure response
    func getWeatherList(search: String, completion : @escaping(Result<ResultWeather, weatherServiceError>) -> ()){
        guard let url = URL(string: search) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, urlResponse, error in
            guard let data = data, let _ = urlResponse as? HTTPURLResponse else{
                completion(.failure(weatherServiceError.timeOut))
                return
            }
            do {
                let weatherList = try JSONDecoder().decode(ResultWeather.self, from: data)
                completion(.success(weatherList))
            } catch {
                completion(.failure(weatherServiceError.cityNotFound))
            }
        }.resume()
    }
}
