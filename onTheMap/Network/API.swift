//
//  API.swift
//  onTheMap
//
//  Created by Raghad Almatrodi on 1/19/19.
//  Copyright © 2019 raghad almatrodi. All rights reserved.
//

import Foundation
class API {
  
    
     static var userInfo = UserInfo()
     static var sessionId: String?
    
    static func postSession(username: String, password: String, completion: @escaping (String?)->Void) {
        guard let url = URL(string: APIConstants.SESSION) else {
            completion("Supplied url is invalid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var errString: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode { //Request sent succesfully
                if statusCode >= 200 && statusCode < 300 { //Response is ok
                    
                    let newData = data?.subdata(in: 5..<data!.count)
                    if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
                        let dict = json as? [String:Any],
                        let sessionDict = dict["session"] as? [String: Any],
                        let accountDict = dict["account"] as? [String: Any]  {
                        
                        self.userInfo.key = accountDict["key"] as? String // This is used in getUserInfo(completion:)
                        self.sessionId = sessionDict["id"] as? String
                        
                        self.getUserInfo(completion: { err in
                            
                        })
                    } else { //Err in parsing data
                        errString = "Couldn't parse response"
                    }
                } else { //Err in given login credintials
                    errString = "Provided login credintials didn't match our records"
                }
            } else { //Request failed to sent
                errString = "Check your internet connection"
            }
            DispatchQueue.main.async {
                completion(errString)
            }
            
        }
        task.resume()
    }
   
    
   static func getUserInfo(completion: @escaping (Error?)->Void) {
        let url = "https://onthemap-api.udacity.com/v1/users/\(self.userInfo.key!)"
        newRequest(url: url, method: "GET") { (status, data) in
            guard status else {
                return
            }
            let newData = data?.subdata(in: 5..<data!.count)
            do {
                let object = try JSONSerialization.jsonObject(with: newData!, options: [])
                //print(object)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
   
  
    class Parser {
      
        static func getStudentLocations(limit: Int = 100, skip: Int = 0, orderBy: SLParam = .updatedAt, completion:
         @escaping (LocationsData?)->Void) {
            guard let url = URL(string: "\(APIConstants.STUDENT_LOCATION)?\(APIConstants.ParameterKeys.LIMIT)=\(limit)&\(APIConstants.ParameterKeys.SKIP)=\(skip)&\(APIConstants.ParameterKeys.ORDER)=-\(orderBy.rawValue)") else {
                completion(nil)
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.get.rawValue
            request.addValue(APIConstants.HeaderValues.PARSE_APP_ID, forHTTPHeaderField: APIConstants.HeaderKeys.PARSE_APP_ID)
            request.addValue(APIConstants.HeaderValues.PARSE_API_KEY, forHTTPHeaderField: APIConstants.HeaderKeys.PARSE_API_KEY)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                var studentLocations: [StudentLocation] = []
                if let statusCode = (response as? HTTPURLResponse)?.statusCode { //Request sent succesfully
                    if statusCode >= 200 && statusCode < 300 { //Response is ok
                        
                        if let json = try? JSONSerialization.jsonObject(with: data!, options: []),
                            let dict = json as? [String:Any],
                            let results = dict["results"] as? [Any] {
                            
                            for location in results {
                                let data = try! JSONSerialization.data(withJSONObject: location)
                                let studentLocation = try! JSONDecoder().decode(StudentLocation.self, from: data)
                                studentLocations.append(studentLocation)
                            }
                            
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    completion(LocationsData(studentLocations: studentLocations))
                }
                
            }
            task.resume()
        }
        
      
     static func postLocation(location: StudentLocation, completion: @escaping (_ status: Bool) -> Void) {
            let url = "https://parse.udacity.com/parse/classes/StudentLocation"
            var params: Data?
            do {
                params = try JSONEncoder().encode(location)
            } catch {
                print(error)
            }
            
            newRequest(url: url, method: "POST", parameters: params) { (status, data) in
                print(String(data: data!, encoding: .utf8))
                guard status else {
                    completion(false)
                    return
                }
                do {
                    let data = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(data)
                    completion(true)
                } catch {
                    print(error)
                    completion(false)
                }
            }
        }
      
        static func logout(completion: @escaping (String?)->Void) {
            
            var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
            request.httpMethod = "DELETE"
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if statusCode >= 200 && statusCode < 300 {
                        if error != nil {
                            return
                        }
                        let range = Range(5..<data!.count)
                        let newData = data?.subdata(in: range)
                        print(String(data: newData!, encoding: .utf8)!)
                    }
                }
                DispatchQueue.main.async {
                   completion("")
                    //return
                }
                
                
            }
            task.resume()
            
        }
        

    }
    
   static func newRequest(url: String, method: String, parameters: Data? = nil, completion: @escaping (_ status: Bool, _ data: Data?) -> Void) {
        
        var request = URLRequest(url: URL(string: url)!)
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        request.httpBody = parameters
        request.httpMethod = method
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse,
                let data = data, (response.statusCode >= 200 && response.statusCode < 300) else {
                    completion(false, nil)
                    return
            }
            completion(true, data)
            }.resume()
    }
}

