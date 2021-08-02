//
//  NetworkManager.swift
//  Photoish app - zavrsni projekt
//
//  Created by Factory on 29.07.2021..
//

import Foundation
import Alamofire
import RxSwift

class NetworkManager {
    
    let apiid = "/?client_id=k3GcmzsSVtz5LcBtsPGFD3gSUZjJYWsQFN8eNjTeWRI"
    
    func getData(from url: String) -> Observable<[Picture]?>{
        let safeUrl = URL(string: url + apiid)
        
        return Observable.create { observer in
            let request = AF.request(safeUrl!).response { response in
                guard let safeData = response.data, response.error == nil, response.response != nil else {
                    observer.onError(response.error!)
                    return
                }
                
                if let decodedObject: [Picture] = SerializationManager().parse(jsonData: safeData){
                    observer.onNext(decodedObject)
                    observer.onCompleted()
                }
                else{
                    print("ERROR: Failed to parse json in Network manager")
                    return
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
 }
