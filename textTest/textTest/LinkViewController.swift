//
//  LinkViewController.swift
//  textTest
//
//  Created by Lai Zih Ci on 2016/8/25.
//  Copyright © 2016年 ZihCiLai. All rights reserved.
//

import UIKit
import CoreBluetooth
class LinkViewController: UIViewController, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var picker: UIPickerView!
    var services: [BTServiceInfo] = []
    var serviceInfo: BTServiceInfo!
    override func viewDidLoad() {
        super.viewDidLoad()

        table.estimatedRowHeight = 40
        table.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }
    // picker view
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        
        return services.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let name = services[row].service.UUID.UUIDString
        
        return name
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let name = services[row].service.UUID.UUIDString
        let color = UIColor.orangeColor()
        let text = NSAttributedString(string: name, attributes: [NSForegroundColorAttributeName: color])
        
        return text
    }
    // tableView
    /*
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        
        return 2
    }*/
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return serviceInfo.characteristics.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TableViewCell
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
