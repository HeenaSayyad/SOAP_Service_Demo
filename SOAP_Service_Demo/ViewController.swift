//
//  ViewController.swift
//  SOAP_Service_Demo
//
//  Created by admin on 05/09/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate {

    @IBOutlet weak var Lbl_CountryCodeValue: UILabel!
    @IBOutlet weak var Lbl_CountryValue: UILabel!
    var currentElementName:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.Call_Web_Service()
        
    }
    
    func Call_Web_Service()
    {
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?> <soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Header><UserCredentials xmlns='http://tempuri.org/'><userName>\("admin")</userName><password>\("$quash.666!")</password></UserCredentials></soap:Header><soap:Body><Country xmlns='http://tempuri.org/' /></soap:Body></soap:Envelope>"
        /*
         let soapMessage = "<?xml version='1.0' encoding='utf-8'?> <soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
         
         <soap:Header><UserCredentials xmlns='http://tempuri.org/'>
         <userName>\("admin")</userName>
         <password>\("$quash.666!")</password>
         </UserCredentials>
         </soap:Header>
         
         <soap:Body>
         <Country xmlns='http://tempuri.org/' />
         </soap:Body>
         
         </soap:Envelope>"

         */
        let urlString = "http://tryusnow.studiolivetv.com/Squash/ServiceCS.asmx"
        let url = URL(string: urlString)
        let theRequest = NSMutableURLRequest(url: url!)
        let msgLength = soapMessage.count
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.addValue("http://tempuri.org/Country", forHTTPHeaderField: "SOAPAction")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        //api call neccessary code
        let task = URLSession.shared.dataTask(with: theRequest as URLRequest) {
            (data, response, error) in
            if data == nil {
                return
            }
            //api call successful
            
            //convert NS data to readable string format to cross verify response. it can be optional
            let desiredString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(desiredString! as String)

            //Parse NS data to readable Dictionary or Array format to send it to UI update (tableview) necessary
            let xmlParser = XMLParser(data: data!)
            xmlParser.delegate = self
            xmlParser.parse()
            xmlParser.shouldResolveExternalEntities = true

        }
        task.resume()
    
    }
    
// XML Parser Delegates
    
    
//- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError;
    
//    -(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
//    -(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
//    -(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElementName = elementName
    }
    //first check the response an accordingly put the name of value
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElementName == "IdNmb"
        {
            print(string)
            self.updateCountryCode(sender: string)
        }
        else if currentElementName == "NameTxt"
        {
            print(string)
            self.updateCountry(sender: string)
        }
    }
    
// write code to update data on UI
    func updateCountryCode(sender: String){
        DispatchQueue.main.async() {
        self.Lbl_CountryCodeValue.text = sender
        }
    }
    
    func updateCountry(sender: String){
         DispatchQueue.main.async() {
        self.Lbl_CountryValue.text = sender
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

