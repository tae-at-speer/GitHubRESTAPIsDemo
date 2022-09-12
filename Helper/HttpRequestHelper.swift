//
//  HttpRequestHelper.swift
//  GitHubRESTAPIsDemo
//
//  Created by Heaven Yip on 2022-09-12.
//

import Foundation

enum HTTPHeaderFields {
    case application_json
    case application_x_www_form_urlencoded
    case none
}

final class HttpRequestHelper {
    
    func GET(url: String, params: [String: Any], httpHeader: HTTPHeaderFields, completion: @escaping (Bool, Data?, String?) -> ()) {
        
        guard var components = URLComponents(string: url) else {
            completion(false, nil,"Error: cannot create URLCompontents")
            return
        }
    
        if !params.keys.isEmpty
        {
            components.queryItems = params.map { key, value in
                URLQueryItem(name: key, value: value as? String)
            }
        }

        guard let url = components.url else {
            completion(false, nil,"Error: cannot create URL")
            return
        }
       
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        switch httpHeader {
        case .application_json:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .application_x_www_form_urlencoded:
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        case .none: break
        }

        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(false, nil, "Error: problem calling GET")
                return
            }
            guard let data = data else {
                print("Error: did not receive data")
                completion(false, nil, "Error: did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                completion(false, nil, "Error: HTTP request failed")
                return
            }
            completion(true, data, nil)
        }.resume()
    }
}
