//
//  BOTRateService.swift
//  BOTRateKit
//
//  Created by Azyukei on 2015/11/29.
//  Copyright © 2015年 Azyukei. All rights reserved.
//

import Foundation

public class RateService {
    public typealias RateDataCompletionBlock = (data: RateData?) -> ()
    
    let botRateBaseAPI = "http://asper-bot-rates.appspot.com/currency.json?"
    let urlSession = NSURLSession.sharedSession()
    
    public class func sharedRateService() -> RateService {
        return _sharedRateService
    }
    
    public func getCurrentRate(currency: String, completion: RateDataCompletionBlock) {
        let botRateAPI = botRateBaseAPI + currency
        print(botRateAPI)
        
        let request = NSURLRequest(URL: NSURL(string: botRateAPI)!)
        let rateData = RateData()
        
        let task = urlSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            guard let data = data else {
                if error != nil {
                    print(error)
                }
                return
            }
            
            // Parse JSON data
            do {
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary
                
                rateData.currency = currency
                rateData.updateTime = jsonResult!["updateTime"] as! Int
                let rates = jsonResult!["rates"] as! NSDictionary
                rateData.buyCash = (rates["buyCash"] as! NSString).doubleValue
                rateData.buySpot = (rates["buySpot"] as! NSString).doubleValue
                rateData.sellCash = (rates["sellCash"] as! NSString).doubleValue
                rateData.sellSpot = (rates["sellSpot"] as! NSString).doubleValue
                
                completion(data: rateData)
                
            } catch {
                print(error)
            }
        })
        
        task.resume()
    }
}

let _sharedRateService: RateService = { RateService() }()