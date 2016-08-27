//
//  ViewController.swift
//  textTest
//
//  Created by Lai Zih Ci on 2016/3/7.
//  Copyright © 2016年 ZihCiLai. All rights reserved.
//

import UIKit
import CoreBluetooth
class ViewController: UIViewController, CBCentralManagerDelegate, UIPickerViewDelegate, CBPeripheralDelegate {
    
    var centeralManager: CBCentralManager!
    var device:[CBPeripheral] = [] // search device
    var rssi: [Int] = [] // rssi
    var signal:[NSNumber] = [] // signal
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var textView: UITextView!
    
    // link
    @IBOutlet weak var linkButton: UIButton!
    //var blueCenteralManager: CBCentralManager!
    var linkDevice: CBPeripheral!
    var services: [BTServiceInfo] = []
    @IBOutlet weak var linkTextView: UITextView!
    
   override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        print("viewDidAppear")
        
        centeralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    @IBOutlet weak var scanButton: UIButton!
    // start scan
    @IBAction func scanAction(sender: UIButton) {
        print("test test")
        device.removeAll(keepCapacity: false)
        rssi.removeAll(keepCapacity: false)
        signal.removeAll(keepCapacity: false)
        
        centeralManager.scanForPeripheralsWithServices(nil, options: nil)

        NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: #selector(ViewController.stop), userInfo: nil, repeats: false)
    }
    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch central.state {
        case CBCentralManagerState.PoweredOn:
            print("open")
        case CBCentralManagerState.PoweredOff:
            print("turn off")
        case CBCentralManagerState.Resetting:
            print("resettion")
        case CBCentralManagerState.Unknown:
            print("Unknown status")
        case CBCentralManagerState.Unauthorized:
            print("closet")
        case CBCentralManagerState.Unsupported:
            print("does not support low energy")
        }
    }
    // stop Ble
    func stop() {
        print("Stop")
        centeralManager.stopScan()
    }
    // pickerView
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        
        return device.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return device[row].name == nil ? "No name!":device[row].name
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        textView.text = ""
        let name = device[row].name == nil ? "No name!":device[row].name!
        textView.text = name+"\n"+(device[row].identifier.UUIDString)+"\n"+"signal:"+signal[row].description+"\n"+"rssi:"+rssi[row].description
        
        linkButton.setTitle("Link"+name, forState: .Normal)
        linkDevice = device[row]
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let name = device[row].name == nil ? "No name!":device[row].name!
        let color = UIColor.orangeColor()
        let text = NSAttributedString(string: name, attributes: [NSForegroundColorAttributeName: color])
        
        return text
    }
    
    func centralManager(central: CBCentralManager, willRestoreState dict: [String : AnyObject]) {
        
        print("willrestoreState")
    }
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        
        print(peripheral.name)
        let name = self.device.filter { (a) -> Bool in
            return a.name == peripheral.name
        }
        
        if name.count == 0 {
            device.append(peripheral)
            rssi.append(RSSI.integerValue)
            signal.append(Int(advertisementData[CBAdvertisementDataIsConnectable]!.description)!)
        }
        print("device.count:\(device.count)")
        picker.reloadAllComponents()
    }
    // Link
    @IBAction func linkAction(sender: UIButton) {
        
        if linkDevice != nil {
            sender.setTitle("Link..", forState: .Normal)
            linkDevice.delegate = self
            centeralManager.connectPeripheral(linkDevice, options: nil)
        } else {
            sender.setTitle("NO Device..", forState: .Normal)
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        
        print("didDiscoverServices")
        for i in peripheral.services! {
            let isService = self.services.filter({ (a) -> Bool in
                return a.service.UUID == i.UUID
            }).count
            if isService == 0 {
                services.append(BTServiceInfo(service: i, characteristics: []))
            }
            peripheral.discoverCharacteristics(nil, forService: i)
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        
        print("didDiscoverCharacteristics")
        if service.characteristics != nil {
            for i in services {
                if i.service.UUID == service.UUID {
                    i.characteristics = service.characteristics!
                    break
                }
            }
        }
        printText()
    }
    
    func printText() {
        let row = picker.selectedRowInComponent(0)
        linkTextView.text = ""
        print("services.count:\(services.count)")
        print("characteristics.count:\(services[row].characteristics.count)")
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        var text = ""
        text += services[indexPath.section].characteristics[indexPath.row].UUID.UUIDString+"\n"
        text += String(format: "0x%02X", services[indexPath.section].characteristics[indexPath.row].properties.rawValue)+"\n"
        text += services[indexPath.section].characteristics[indexPath.row].getPropertyContent()+"\n"
        text += services[indexPath.section].characteristics[indexPath.row].UUID.description+"\n"
        text += services[indexPath.section].characteristics[indexPath.row].value?.description ?? "null"
        linkTextView.text = text
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "link" {
            let link = segue.destinationViewController as! LinkViewController
            link.services = self.services
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("didConnectPeripheral")
        peripheral.discoverServices(nil)
    }
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("didFailToConnectPeripheral")
    }
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("didDisconnectPeripheral")

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension CBCharacteristic {
    
    func isWritable() -> Bool {
        
        return (self.properties.intersect(CBCharacteristicProperties.Write)) != []
    }
    
    func isReadable() -> Bool {
        return (self.properties.intersect(CBCharacteristicProperties.Read)) != []
    }
    
    func isWritableWithoutResponse() -> Bool {
        return (self.properties.intersect(CBCharacteristicProperties.WriteWithoutResponse)) != []
    }
    
    func isNotifable() -> Bool {
        return (self.properties.intersect(CBCharacteristicProperties.Notify)) != []
    }
    
    func isIdicatable() -> Bool {
        return (self.properties.intersect(CBCharacteristicProperties.Indicate)) != []
    }
    
    func isBroadcastable() -> Bool {
        return (self.properties.intersect(CBCharacteristicProperties.Broadcast)) != []
    }
    
    func isExtendedProperties() -> Bool {
        return (self.properties.intersect(CBCharacteristicProperties.ExtendedProperties)) != []
    }
    
    func isAuthenticatedSignedWrites() -> Bool {
        return (self.properties.intersect(CBCharacteristicProperties.AuthenticatedSignedWrites)) != []
    }
    
    func isNotifyEncryptionRequired() -> Bool {
        return (self.properties.intersect(CBCharacteristicProperties.NotifyEncryptionRequired)) != []
    }
    
    func isIndicateEncryptionRequired() -> Bool {
        return (self.properties.intersect(CBCharacteristicProperties.IndicateEncryptionRequired)) != []
    }
    
    
    func getPropertyContent() -> String {
        var propContent = ""
        if (self.properties.intersect(CBCharacteristicProperties.Broadcast)) != [] {
            propContent += "Broadcast,"
        }
        if (self.properties.intersect(CBCharacteristicProperties.Read)) != [] {
            propContent += "Read,"
        }
        if (self.properties.intersect(CBCharacteristicProperties.WriteWithoutResponse)) != [] {
            propContent += "WriteWithoutResponse,"
        }
        if (self.properties.intersect(CBCharacteristicProperties.Write)) != [] {
            propContent += "Write,"
        }
        if (self.properties.intersect(CBCharacteristicProperties.Notify)) != [] {
            propContent += "Notify,"
        }
        if (self.properties.intersect(CBCharacteristicProperties.Indicate)) != [] {
            propContent += "Indicate,"
        }
        if (self.properties.intersect(CBCharacteristicProperties.AuthenticatedSignedWrites)) != [] {
            propContent += "AuthenticatedSignedWrites,"
        }
        if (self.properties.intersect(CBCharacteristicProperties.ExtendedProperties)) != [] {
            propContent += "ExtendedProperties,"
        }
        if (self.properties.intersect(CBCharacteristicProperties.NotifyEncryptionRequired)) != [] {
            propContent += "NotifyEncryptionRequired,"
        }
        if (self.properties.intersect(CBCharacteristicProperties.IndicateEncryptionRequired)) != [] {
            propContent += "IndicateEncryptionRequired,"
        }
        
        if !propContent.isEmpty {
            propContent = propContent.substringToIndex(propContent.endIndex.advancedBy(-1))
        }
        
        return propContent
    }
}
class BTServiceInfo {
    var service: CBService!
    var characteristics: [CBCharacteristic]
    init(service: CBService, characteristics: [CBCharacteristic]) {
        self.service = service
        self.characteristics = characteristics
    }
}