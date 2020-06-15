import UIKit

struct Person: Decodable {
    let name: String
    let films: [URL]
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

class SwapiService {
    static private let baseURL = URL(string: "https://swapi.dev/api")
    static let peopleEndpoint = "people"
    static let filmEndpoint = "films"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        //Prepare URL
        guard let baseURL = baseURL else {return completion(nil)}
        let secondURL = baseURL.appendingPathComponent(peopleEndpoint)
        let finalURL = secondURL.appendingPathComponent("\(id)")
        print(finalURL)
        //Contact Server
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print(error)
                print(error.localizedDescription)
                print("We had an error fetching the categories")
            }
            guard let data = data else {return completion(nil)}
            
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                return completion(person)
            } catch {
                print("We had an error decoding the data - \(error) - \(error.localizedDescription)")
                return completion(nil)
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("we had an error fetching the films - \(error) - \(error.localizedDescription)")
            }
            guard let data = data else {return completion(nil)}
            
            do {
                let film = try JSONDecoder().decode(Film.self, from: data)
                return completion(film)
            } catch {
                print("There was an error decoding our films - \(error) - \(error.localizedDescription)")
                return completion(nil)
            }
        }.resume()
    }
}


SwapiService.fetchPerson(id: 10) { (person) in
    if let person = person {
        print(person)
        for person in person.films {
            SwapiService.fetchFilm(url: person) { (film) in
                if let film = film {
                    print(film)
                }
            }
        }
    }
}
func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { (film) in
        if let film = film {
            print(film)
        }
    }
}

