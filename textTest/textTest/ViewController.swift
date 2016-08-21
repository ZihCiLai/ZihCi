//
//  ViewController.swift
//  textTest
//
//  Created by Lai Zih Ci on 2016/3/7.
//  Copyright © 2016年 ZihCiLai. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate {
    let ss = 1234
    var sender: UIButton!
    
    var picker: UIPickerView!
    @IBOutlet weak var textView: UITextView!
    var butt: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let long = UILongPressGestureRecognizer(target: self, action: #selector(self.long))
        long.minimumPressDuration = 0.5
        long.numberOfTouchesRequired = 1
        long.numberOfTapsRequired = 0
        
        butt = UIButton(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
        butt.backgroundColor = UIColor.blueColor()
        butt.addGestureRecognizer(long)
        //view.addSubview(butt)
        textView.clearsOnInsertion = true
        textView.hidden = true
        
        picker = UIPickerView()
        picker.frame = CGRect(x: 0, y: 50, width: 150, height: 130)
        picker.backgroundColor = UIColor.yellowColor()
        
        picker.delegate = self
        self.view.addSubview(picker)
        
        sender = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        sender.backgroundColor = UIColor.redColor()
        sender.setImage(UIImage(named: "text"), forState: .Normal)
        view.addSubview(sender)
        if sender.currentImage != UIImage(named: "ext") {
            print("text")
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    var selectAudio = ""

    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int
    {
        return 3
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch row {
        case 0:
            return "0"
        case 1:
            return "1"
        default:
            return "2"
        }
        
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //selectAudio = audio[row]!
        //timeButton.setTitle(audio[row], forState: .Normal)
        print(picker.rowSizeForComponent(0))
        //print(component)
    }

    
    func long() {
        print("sdfssaass")
    }
    @IBAction func button(sender: UIButton) {
        print("test test")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

