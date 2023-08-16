import Foundation

class ApiService: NSObject {
    
    /*calling a web service*/
    func getWeatherList(search: String, onSuccess : @escaping(Result) -> Void, onError: @escaping(String) -> Void){
        guard let url = URL(string: search) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, urlResponse, error in
            guard let data = data, let response = urlResponse as? HTTPURLResponse else{
                onError("error occured")
                return
            }
            do {
                if response.statusCode == 200 {
                    let weatherList = try JSONDecoder().decode(Result.self, from: data)
                    onSuccess(weatherList)
                } else {
                    if response.statusCode == 404 {
                        onError("city not found")
                    } else {
                        onError("error code :" + "\(response.statusCode)")
                    }
                }
            } catch {
                onError(error.localizedDescription)
            }
        }.resume()
    }
}
