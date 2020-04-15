//
//  ViewController.swift
//  DynamicUI
//
//  Created by Admin on 05/02/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var dynamicList:[DynamicDataModel] = []
        
    @IBOutlet weak var dynamicDataTV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        readingData()
    }

    func readingData()  {
        if let path = Bundle.main.path(forResource: "DataOfDemo", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as?  [[String:Any]] {
                    for user in jsonResult{
                        let model = DynamicDataModel(dict: user)
                        dynamicList.append(model)
                        
                    }
                    DispatchQueue.main.async {
                        self.dynamicDataTV.reloadData()
                    }
//                    dynamicList  = jsonResult.compactMap {DynamicDataModel(dict: $0)}
                    print("Printing the value: ",jsonResult)
                }
            } catch {
                // handle error
            }
        }
    }
    
    func sendUrlRequestToServer(url:String,parameters:[String:Any]?,taskType:Int,complitionHandler:@escaping ((Any,Bool)->Void))
    {
        guard let url = URL(string:url)
            else{
                print("url not formed")
                return
        }
        let urlRequest:NSMutableURLRequest = NSMutableURLRequest.init(url: url)
        
        if(parameters != nil)
        {
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters as Any, options: [])
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = jsonData;
        }
        
        print("URL:", url)
        print("Parameters:", parameters)
        
        if let anAccesstoken = SharedManager.shared.getValueFromUserDefaults(for: K_ACCESS_TOKEN) as? String
        {
            let authToken = "bearer" + " " + anAccesstoken
            print(">>>>>>>AUTH TOKEN IS  >>>>>>>",authToken)
            print(">>>>>>>>>DEVICE ID IS>>>>>>",SharedManager.shared.getDeviceID())
            urlRequest.setValue(authToken, forHTTPHeaderField: "Authorization")
        }
        else{
            
            urlRequest.setValue(keyForAccessToken, forHTTPHeaderField: "key")
            
        }
        urlRequest.setValue(SharedManager.shared.getDeviceID(), forHTTPHeaderField: "DeviceID")
        urlRequest.setValue(SharedManager.shared.getCountryId(), forHTTPHeaderField: "CountryID")
        print(">>>>>>>>>Country ID IS>>>>>>",SharedManager.shared.getCountryId())
        
        HttpCommunication.sharedInstance.httpCommunicationWithRequest(url: urlRequest as URLRequest) { (response,success) in
            complitionHandler(response,success)
        }
    }

    
    func httpCommunicationWithRequest(url:URLRequest,  complitionHandler:@escaping ((Any,Bool)->Void))
    {
        let config:URLSessionConfiguration = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0
        config.timeoutIntervalForResource = 60.0
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url as URLRequest) { (data, response, error) in
            guard error == nil && data != nil else {
                
                DispatchQueue.main.async(execute: {
                    complitionHandler(error as Any,false)
                })

                return
            }
            do {
               
                if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200
                {
                    
                    if httpStatus.statusCode == 401{
                        
                    }
                    
                    let responseString = try  JSONSerialization.jsonObject(with: (data)!, options: [])
                    DispatchQueue.main.async(execute: {
                        complitionHandler(responseString as Any,false)
                    })
                    
                    return
                }
                else{
                    
                    if(data?.count == 0)
                    {
                        DispatchQueue.main.async(execute: {
                            complitionHandler("Ok",true)
                        })
                        return
                    }
                    let responseString = try  JSONSerialization.jsonObject(with: (data)!, options:.allowFragments)
                    DispatchQueue.main.async(execute: {
                        complitionHandler(responseString,true)
                    })
                }
            }catch let error as NSError
            {
                DispatchQueue.main.async(execute: {
                    complitionHandler(error,false)
                })
            }
            
        }
        task.resume()
    }

    

}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dynamicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dynamicList[indexPath.row]
        switch model.type ?? "" {
        case "TextArea":
            let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicCell1") as! DynamicCell1
            cell.dropDownBtn.isHidden = true
            return cell
            
        case "TextView" :
            let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicCell2") as! DynamicCell1
            return cell
            
        case "DropDown":
            let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicCell1") as! DynamicCell1
            cell.dropDownBtn.setTitle("DD", for: .normal)
            cell.dropDownBtn.isHidden = false
            return cell
        case "DTO":
            let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicCell1") as! DynamicCell1
            cell.dropDownBtn.setTitle("DTO", for: .normal)
            cell.dropDownBtn.isHidden = false
            return cell
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
        
    }
    
    
}

