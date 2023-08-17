import Foundation

struct ResultWeather: Codable {
    let visibility: Double
    let name: String?
    let weather:[Weather]
}

struct Weather: Codable {
    let id: Int
    let main: String?
    let description:String?
    let icon:String?
}
