//
//  ViewController.swift
//  Heart Attack Alarm
//
//  Created by Daniel Camargo on 10/11/19.
//  Copyright © 2019 Daniel Camargo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let center = UNUserNotificationCenter.current()

        timeSlider.value = 10;
        timeLabel.text = "\(redableTime(time: 0)):\(redableTime(time: 0)):\(redableTime(time: 10))"
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("Hunf!")
            }
        }
    }
    
    func getSound() -> String {
        return ["sound-02.caf", "sound-04.caf", "sound-04.caf", "sound-05.caf", "sound-06.caf"].randomElement()!
    }

    @IBAction func scheduleAlarm(_ sender: Any) {
        showConfirmationMessage()
    }
    
    func createNotification() {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Time to wake up!"
        content.body = "Wakeeeeeee upppppppppp!"
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: getSound()))
        
        let interval = TimeInterval(Int.random(in: 10...Int(timeSlider.value)))

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func putAppInBackground(alertAction: UIAlertAction) {
        createNotification()
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
    }
    
    func showConfirmationMessage() {
        let alert = UIAlertController(title: "Heart Attack!", message: "It is done! Now close your eyes and try to sleep!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: putAppInBackground))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        
        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: currentValue)
        timeLabel.text = "\(redableTime(time: h)):\(redableTime(time: m)):\(redableTime(time: s))"
    }
    
    func redableTime(time: Int) -> String {
        return (time >= 10) ? "\(time)" : "0\(time)"
    }
    
    func secondsToHoursMinutesSeconds (seconds: Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}

