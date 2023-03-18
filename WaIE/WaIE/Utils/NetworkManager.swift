//
//  NetworkManager.swift
//  WaIE
//
//  Created by Anshu Vij on 18/03/23.
//

import Foundation

//class NetworkManager {
//
//
//    static let shared = NetworkManager()
//
//    func requestData<T: Codable>(url:String, completion: @escaping (Result<T, Error>) -> ()) {
//
//        guard let url = URL(string: url) else {
//            print("Error: cannot create url")
//            return
//        }
//        let urlRequest = URLRequest(url: url)
//        let session = URLSession(configuration: .default)
//        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
//            if let err = error {
//                completion(.failure(err))
//                print(err.localizedDescription)
//                return
//            }
//            guard response != nil, let data = data else {
//                return
//            }
//
//            do {
//                let response = try JSONDecoder().decode(T.self, from: data)
//                    completion(.success(response))
//            } catch let error {
//                completion(.failure(error))
//            }
//        }
//        dataTask.resume()
//    }
//}
enum CustomError: Error {
    case BadURL
    case NoData
    case DecodingError
    case Offline
}
class NetworkManager {
    
    let aPIHandler: APIHandlerDelegate
    let responseHandler: ResponseHandlerDelegate
    
    init(aPIHandler: APIHandlerDelegate = APIHandler(),
         responseHandler: ResponseHandlerDelegate = ResponseHandler()) {
        self.aPIHandler = aPIHandler
        self.responseHandler = responseHandler
    }
    
    func requestData<T: Codable>(type: T.Type,url:URL, completion: @escaping (Result<T, CustomError>) -> ()) {
        
        
        aPIHandler.fetchData(url: url) { result in
            switch result {
            case .success(let data):
                self.responseHandler.fetchModel(type: type, data: data) { decodedResult in
                    switch decodedResult {
                    case .success(let model):
                        completion(.success(model))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    
}

protocol APIHandlerDelegate {
    func fetchData(url: URL, completion: @escaping(Result<Data, CustomError>) -> Void)
}

class APIHandler: APIHandlerDelegate {
    func fetchData(url: URL, completion: @escaping(Result<Data, CustomError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.NoData))
            }
            completion(.success(data))
           
        }.resume()
    }
    
}

protocol ResponseHandlerDelegate {
    func fetchModel<T: Codable>(type: T.Type, data: Data, completion: (Result<T, CustomError>) -> Void)
}

class ResponseHandler: ResponseHandlerDelegate {
    func fetchModel<T: Codable>(type: T.Type, data: Data, completion: (Result<T, CustomError>) -> Void) {
        let commentResponse = try? JSONDecoder().decode(type.self, from: data)
        if let commentResponse = commentResponse {
            return completion(.success(commentResponse))
        } else {
            completion(.failure(.DecodingError))
        }
    }
    
}
