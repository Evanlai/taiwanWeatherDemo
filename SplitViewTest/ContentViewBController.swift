//
//  ContentViewBController.swift
//  SplitViewTest
//
//  Created by Lai Evan on 10/3/17.
//  Copyright © 2017 Lai Evan. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash
import CoreLocation
import ObjectMapper

class ContentViewBController: ContentViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,CLLocationManagerDelegate {
  
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var cityimageView: UIImageView!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var cityTempLabel: UILabel!
    
    @IBOutlet weak var cityWeatherNameLabel: UILabel!
    
    @IBOutlet weak var cityTableCell: UITableView!
    
    var weatherData:XMLIndexer?
    
    var locationData:XMLIndexer?
    
    var locationInfo:LocationInfo?
    
    var cityParameterValue:Int?
    
    var locationBool:Bool = false
    
    var tempValueIndex = 0
    
    var cancelStatus:Bool = false
    
    var searchController: UISearchController!
    
    var cityArray = ["台北市,0","新北市,1","桃園市,2","臺中市,3","臺南市,4","高雄市,5","基隆市,6","新竹縣,7","新竹市,8","苗栗縣,9","彰化縣,10","南投縣,11","雲林縣,12","嘉義縣,13","嘉義市,14","屏東縣,15","宜蘭縣,16","花蓮縣,17","臺東縣,18","澎湖縣,19","金門縣,20","連江縣,21"]
    var cityFilterArray = [Any]()
    
    var cityValue:Int?
    
    var myLocationManager:CLLocationManager!
    
    

    override func viewDidLoad() {

        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search City here..."
        
        searchController.searchBar.delegate = self
        
        searchController.searchBar.showsCancelButton = true
        
        searchController.searchBar.sizeToFit()
        
        searchController.hidesNavigationBarDuringPresentation = false
    
        //searchController.disablesAutomaticKeyboardDismissal = false
       
        self.navigationItem.titleView = searchController.searchBar
        
        // 建立一個 CLLocationManager
        myLocationManager = CLLocationManager()
        
        // 設置委任對象
        myLocationManager.delegate = self
        
        // 距離篩選器 用來設置移動多遠距離才觸發委任方法更新位置
        myLocationManager.distanceFilter =
        kCLLocationAccuracyNearestTenMeters
        
        // 取得自身定位位置的精確度
        myLocationManager.desiredAccuracy =
        kCLLocationAccuracyBest
    
        getCWBWeather()

    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cityFilterArray.count
    
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return 1
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell" , for: indexPath)
        
        let splitStr = (cityFilterArray[indexPath.row] as? String)?.components(separatedBy: ",")
        
        cell.textLabel?.text = splitStr?[0]
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let splitStr = (cityFilterArray[indexPath.row] as? String)?.components(separatedBy: ",") else {
            
            return
            
        }
        
        //取得縣市的ID
        cityValue = Int((splitStr[1]))

        cityTableCell.isHidden = true
        
        self.collectionView.reloadData()

    }
    

    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchString = searchController.searchBar.text else{ return }
        
        cityFilterArray = cityArray.filter({ (cityfilter) -> Bool in
      
            return cityfilter.lowercased().contains(searchString.lowercased())
 
        })
        
        if(cancelStatus == false){
            
            cityTableCell.isHidden = false
            
            cityTableCell.reloadData()
            
        }else{
            
            cancelStatus = true
            
            cityTableCell.reloadData()

        }
        
    }
    
    
    // 定位後拆解縣市名稱
    func locationSearchResults(){
    
        var citySortCount = -1
        
        var locationItem = self.locationInfo?.results
        
        let locationCity = locationItem?[(locationItem?.count)! - 2].addressItem?[0].long_name
        
        guard let searchString = locationCity else{ return }
        
        cityFilterArray = cityArray.filter({ (cityfilter) -> Bool in
            
            citySortCount += 1
   
            return cityfilter.lowercased().contains(searchString.lowercased()+",\(citySortCount)")
            
        })
        
        guard let splitStr = (cityFilterArray[0] as? String)?.components(separatedBy: ",") else {
            
            return
            
        }
        
        cityValue = Int((splitStr[1]))
        
        cityTableCell.isHidden = true
        
        self.cityTableCell.reloadData()
        
        self.collectionView.reloadData()
    
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        
        searchController.searchBar.resignFirstResponder()
        
    }
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        cityTableCell.isHidden = true
        
        cancelStatus = true
        
    }
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        cityTableCell.isHidden = false
        
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        cityTableCell.isHidden = true
    
    }
    
    
    //==== collectionView  ====//
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 7
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! MyBCollectionViewCell
        
        if (cityValue == 0 || cityValue == nil){ cityValue = 0 }
        
        if (indexPath.row == 0){
            
            tempValueIndex = 0

        }else{
            
            tempValueIndex = indexPath.row + indexPath.row
            
        }
        
        guard let Citytitle = self.weatherData?["cwbopendata"]["dataset"]["location"] [cityValue!]["locationName"].element?.text,
        
        let TemperatureMaxLabel = self.weatherData?["cwbopendata"]["dataset"]["location"] [cityValue!]["weatherElement"] [1]["time"] [tempValueIndex]["parameter"] [0]["parameterName"].element?.text,
        
        let TempertureMinLabel = self.weatherData?["cwbopendata"]["dataset"]["location"] [cityValue!]["weatherElement"] [2]["time"] [tempValueIndex]["parameter"] [0]["parameterName"].element?.text,

        let WeatherNameLabel = self.weatherData?["cwbopendata"]["dataset"]["location"] [cityValue!]["weatherElement"] [0]["time"] [tempValueIndex]["parameter"] [0]["parameterValue"].element?.text
        
        else {return cell}
        
        
        // 設定主畫面資訊。
        if (indexPath.row == 0){
            
            cityimageView.image = UIImage(named: getCWBImage(imageName: Int(WeatherNameLabel)!))
            
            cityNameLabel.text = Citytitle
            
            cityTempLabel.text = TempertureMinLabel + "°~" + TemperatureMaxLabel + "°"
            
            cityWeatherNameLabel.text = self.weatherData?["cwbopendata"]["dataset"]["location"] [cityValue!]["weatherElement"] [0]["time"] [0]["parameter"] [0]["parameterName"].element?.text
            
        }
        
        cell.weatherImage.image = UIImage(named: getCWBImage(imageName: Int(WeatherNameLabel)!))
        
        cell.weekLabel.text = getDateWeekday(days: indexPath.row)
        
        cell.tempMax.text = TemperatureMaxLabel + "°"
        
        cell.tempMin.text = TempertureMinLabel + "°"
        
        //tempValueIndex += 2
        
        
        return cell
        
    }
    
    
    
    // 將數字轉成國字日期
    func getDateWeekday(days:Int) -> String {
        
        var daysToAdd = days - 1
        
        var dayConvertWord = ""
        
        var newDate = Calendar.current.date(byAdding: .hour, value: 0, to: Date())
        
        newDate = Calendar.current.date(byAdding: .day, value: days, to: newDate!)
        
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        var myComponents = myCalendar.components(.weekday, from: newDate!)
        
        guard let dateday = myComponents.weekday else { return "" }
        
        switch dateday - 1 {
        
        case 1:
            
            dayConvertWord = "一"
            
        case 2:
            
            dayConvertWord = "二"
            
        case 3:
            
            dayConvertWord = "三"
            
        case 4:
            
            dayConvertWord = "四"
            
        case 5:
            
            dayConvertWord = "五"
            
        case 6:
            
            dayConvertWord = "六"
            
        default:
            
            dayConvertWord = "日"
            
        }
        

        return dayConvertWord
    
    }
    
    
    
    // Get WeatherImage.
    func getCWBImage(imageName:Int) -> String {
        
        var imagesName = ""
        
        switch imageName {
        
        //晴
        case 1:
            imagesName = "sun"
        
        //多雲
        case 2:
            imagesName = "cloud"
        
        //陰天
        case 3:
            imagesName = "cloud"
        
        //多雲時晴
        case 5:
            imagesName = "cloudmoresun"
            
        //陰時多雲
        case 6:
            imagesName = "cloudmore"
            
        //多雲時晴
        case 7:
            imagesName = "cloudmoresun"
        
        //晴時多雲
        case 8:
            imagesName = "sunmorecloud"
        
        //多雲短暫陣雨
        case 12:
            imagesName = "cloudmorerain"
        
        //午後多雲短暫雷陣雨
        case 18,36:
            imagesName = "rain"
        
        //陰時多雲短暫陣雨、陰短暫陣雨
        case 26,31:
            imagesName = "cloudmorerain"
            
        default:
            imagesName = "sun"
            
        }
        
        
        return imagesName
    }

    
    // 未來七天天氣預報
    func getCWBWeather(){
    
        let xmlToParse = "http://opendata.cwb.gov.tw/opendata/MFC/F-C0032-005.xml"
        
        Alamofire.request(xmlToParse, parameters: nil) //Alamofire defaults to GET requests
            .response { response in
                if let data = response.data {
                    
                    self.weatherData = SWXMLHash.parse(data)
                    
                    self.collectionView.reloadData()
                    
                }
        }
    }
    
    
    //
    func getLocationXY(lat:Double,long:Double){
        
        let xmlToParse = "http://maps.googleapis.com/maps/api/geocode/json?latlng=24.953932900279302,121.50401489065428&sensor=false&language=zh-tw"
        
    
        // Alamofire 讀取 JSON 網址 資料
        Alamofire.request(xmlToParse).responseJSON{ response in
            
            guard response.result.isSuccess else{
                
                _ = response.result.error?.localizedDescription
                
                
                return
            }
            
            
            guard let JSON = response.result.value as? [String:Any] else{
                
                return
                
            }
            
            
            // JSON資料帶入 YotubeInfo # ObjectMapper # 作解析
            self.locationInfo = LocationInfo(JSON:JSON)
            
            self.locationSearchResults()
        
        }
    }
    
    
    // 模擬器定位有問題，需裝上實體機器才會正常
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]){
        
        //取得目前座標
        let currentLocation:CLLocation = locations[0] as CLLocation
        
        print(currentLocation.coordinate.latitude)
        print(currentLocation.coordinate.longitude)
        
        
        getLocationXY(lat: currentLocation.coordinate.latitude,long: currentLocation.coordinate.longitude)
        
    }
    
    
    
    // 授權定位權限
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        
        // 首次使用 向使用者詢問目前定位的權限
        if CLLocationManager.authorizationStatus() == .notDetermined{
        
            // 取得定位服務授權
            myLocationManager.requestWhenInUseAuthorization()
            
            // 開始定位自身位置
            myLocationManager.startUpdatingHeading()
        
        }
        
        // 使用者已經拒絕定位的權限
        else if CLLocationManager.authorizationStatus() == .denied{
        
            //提示可至 設定 中開啟權限
            let alertController = UIAlertController(title: "定位權限已關閉", message: "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
            
            self.present(alertController, animated: true, completion: nil)
            
            
        }
        
        // 使用者已經同意定位自身位置權限
        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
        
            // 開始定位目前位置
            myLocationManager.startUpdatingLocation()
        
        }
    
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        // 停止定位自身位置
        myLocationManager.stopUpdatingLocation()
        
    }
    
    
    
    @IBOutlet weak var CityDetailImage: UIImageView!
    
    
    
    
    

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CityWeatherDetail" {
            
            
            
            
            
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
    }
 

}
