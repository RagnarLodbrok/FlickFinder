//
//  ViewController.swift
//  FlickrFinder
//
//  Created by Gil Felot on 30/08/15.
//  Copyright (c) 2015 Gil Felot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var flickImage: UIImageView!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleSearch: UIButton!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var gpsSearch: UIButton!
    
    let BASE_URL = "https://api.flickr.com/services/rest/"
    let METHOD_NAME = "flickr.galleries.getPhotos"
    let API_KEY = "f931c2aa41c5b906e9d3dec18cc78e63"
    let GALLERY_ID = "66911286-72157647263150569"
    let EXTRAS = "url_m"
    let DATA_FORMAT = "json"
    let NO_JSON_CALLBACK = "1"
    let SAFE_SEARCH = "1"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func titleSearchAction(sender: AnyObject) {
        /* 1 - Hardcode the arguments */
        let methodArguments = [
            "method": METHOD_NAME,
            "api_key": API_KEY,
            "text": "baby asian elephant",
            "safe_search": SAFE_SEARCH,
            "extras": EXTRAS,
            "format": DATA_FORMAT,
            "nojsoncallback": NO_JSON_CALLBACK
        ]
        /* 2 - Call the Flickr API with these arguments */
        getImageFromFlick(methodArguments)
    }
    
    func getImageFromFlick(methodArguments: [String : AnyObject]) {
        /* 3 - Get the shared NSURLSession to faciliate network activity */
        let session = NSURLSession.sharedSession()
        /* 4 - Create the NSURLRequest using properly escaped URL */
        let urlString = BASE_URL + escapedParameters(methodArguments)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        /* 5 - Create NSURLSessionDataTask and completion handler */
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if let error = downloadError {
                println("Could not complete the request \(error)")
            } else {
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                println(parsedResult.valueForKey("photos"))
            }
        }
        
        /* 6 - Resume (execute) the task */
        task.resume()
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }

    
    @IBAction func gpsSearchAction(sender: AnyObject) {
    }
    
}

