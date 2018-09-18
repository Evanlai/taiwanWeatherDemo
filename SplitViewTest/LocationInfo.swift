//
//  LocationInfo.swift
//  SplitViewTest
//
//  Created by Lai Evan on 10/12/17.
//  Copyright © 2017 Lai Evan. All rights reserved.
//

import ObjectMapper

class LocationInfo: Mappable {
    
    var results: [LocationItem]?
    
    required init?(map: Map) {
        
        
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        results  <- map["results"]
        
    }

}


class LocationItem: Mappable{

    var addressItem:[addressItems]?
    
    required init?(map: Map) {
        
        
        
    }
    
    
    // Mappable
    func mapping(map: Map) {
        
        addressItem <- map["address_components"]
        
    }
    

}


class addressItems: Mappable{


    var long_name:String?
    var short_name:String?
    
    
    required init?(map: Map) {
        
        
        
    }
    
    
    // Mappable
    func mapping(map: Map) {
        
        long_name <- map["long_name"]
        short_name <- map["short_name"]
       
        
    }


}

