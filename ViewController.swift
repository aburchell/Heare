//
//  ViewController.swift
//  Heare
//
//  Created by Gus Burchell on 3/25/17.
//  Copyright © 2017 Gus Burchell. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit
import CoreLocation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    var heareSounds = [String: String]()
    
   
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - location manager to authorize user location for Maps app
    var locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            //locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
        
    }
    /**
    var myLocation: CLLocationCoordinate2D?
    
    @IBOutlet weak var locationButton: UIButton!
    @IBAction func printLocation(_ sender: Any) {
        if let meHere = mapView.userLocation.location?.coordinate{mapView.setCenter(meHere, animated: true)
            let region = MKCoordinateRegion(center: meHere, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            mapView.setRegion(region, animated: true)
        
        
            let annot:MKPointAnnotation = MKPointAnnotation()
            annot.coordinate = meHere
            self.mapView.addAnnotation(annot)
        }
    **/
    
 
    
    
    
 
    
    
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    
    
    
    @IBOutlet weak var RecordBtn: UIButton!
 
    @IBOutlet weak var PlayBtn: UIButton!
    
    @IBOutlet weak var randomButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PlayBtn.isEnabled = false
        randomButton.isEnabled = false
        let fileMgr = FileManager.default
        
        let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        
        /**
        let soundFileURL = dirPaths[0].appendingPathComponent("sound.caf")
        print(soundFileURL)
        let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue, AVEncoderBitRateKey: 16, AVNumberOfChannelsKey: 2, AVSampleRateKey: 44100.0] as[String : Any]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(
                AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL, settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession Error: \(error.localizedDescription)")
        }
        **/
    }
    /**
    @IBAction func recordAudio(_ sender: AnyObject){
        if audioRecorder?.isRecording == false {
            PlayBtn.isEnabled = false
            StopBtn.isEnabled = true
            audioRecorder?.record()
        }
    }
    **/
    
    var soundIndex = 0
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        
            
            var whereAt = mapView.userLocation.coordinate
            var curLong = String(whereAt.longitude)
            var curLat = String(whereAt.latitude)
        
            heareSounds[String(soundIndex)] = curLong + ":" + curLat
        
        
            let fileMgr = FileManager.default
            
            let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
            
            let soundFileURL = dirPaths[0].appendingPathComponent("sound" + String(soundIndex) + "caf")
            print(soundFileURL)
            let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue, AVEncoderBitRateKey: 16, AVNumberOfChannelsKey: 2, AVSampleRateKey: 44100.0] as[String : Any]
            
            let audioSession = AVAudioSession.sharedInstance()
            
            do {
                try audioSession.setCategory(
                    AVAudioSessionCategoryPlayAndRecord)
            } catch let error as NSError {
                print("audioSession error: \(error.localizedDescription)")
            }
            
            do {
                try audioRecorder = AVAudioRecorder(url: soundFileURL, settings: recordSettings as [String : AnyObject])
                audioRecorder?.prepareToRecord()
            } catch let error as NSError {
                print("audioSession Error: \(error.localizedDescription)")
            }
        
        
        
        if audioRecorder?.isRecording == false {
            PlayBtn.isEnabled = false
            audioRecorder?.record()
            soundIndex = soundIndex + 1
        randomButton.isEnabled = true
        }
    }
    /**
    func recordAudio() {
        if audioRecorder?.isRecording == false {
            PlayBtn.isEnabled = false
            
            
            
            audioRecorder?.record()
            //var whereAt = getCurrentCoord()
            //print(whereAt.latitude)
        }
    }
    **/
    @IBAction func stopAudio(_ sender: AnyObject) {
        PlayBtn.isEnabled = true
        RecordBtn.isEnabled = true
        
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        } else {
            audioPlayer?.stop()
        }
    }
    
    /**
    @IBAction func stopAudio(_ sender: AnyObject) {
        StopBtn.isEnabled = false
        PlayBtn.isEnabled = true
        RecordBtn.isEnabled = true
        
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        } else {
            audioPlayer?.stop()
        }
    }
    **/
    
    @IBAction func playAudio(_ sender: AnyObject) {
        if audioRecorder?.isRecording == false {
            RecordBtn.isEnabled = false
            
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: (audioRecorder?.url)!)
                audioPlayer!.delegate = self
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            } catch let error as NSError {
                print("audioPlayer error: \(error.localizedDescription)")
            }
        }
        print(heareSounds.count)
    }

    @IBAction func playRandom(_ sender: Any) {
        var randNum = arc4random_uniform(UInt32(heareSounds.count))
        var coordinates = heareSounds[String(randNum)]
        print(coordinates)
        var annotCoordsLong = ""
        var annotCoordsLat = ""
        
        var stillInLong = true
        for character in (coordinates?.characters)!{
            if character != ":" {
                if stillInLong {
                    annotCoordsLong = annotCoordsLong + String(character)
                } else {
                    annotCoordsLat = annotCoordsLat + String(character)
                }
            } else {
                stillInLong = false
            }
        }
        
        var recordedLocation = CLLocationCoordinate2D.init(latitude: Double(annotCoordsLat)!, longitude: Double(annotCoordsLong)!)
       
        
        let region = MKCoordinateRegion(center: recordedLocation, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        mapView.setRegion(region, animated: true)
        
        
        let annot:MKPointAnnotation = MKPointAnnotation()
        annot.coordinate = recordedLocation
        self.mapView.addAnnotation(annot)
        
        
        
        //Handles the playing of the sound
        
        PlayBtn.isEnabled = true
        RecordBtn.isEnabled = true
        
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        } else {
            audioPlayer?.stop()
        }
        
        let fileMgr = FileManager.default
        let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        let soundFileURL = dirPaths[0].appendingPathComponent("sound" + String(randNum) + "caf")
        //print(soundFileURL)
        let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue, AVEncoderBitRateKey: 16, AVNumberOfChannelsKey: 2, AVSampleRateKey: 44100.0] as[String : Any]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(
                AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL, settings: recordSettings as [String : AnyObject])
        //   audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession Error: \(error.localizedDescription)")
        }
        
        if audioRecorder?.isRecording == false {
            RecordBtn.isEnabled = false
            
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: (audioRecorder?.url)!)
                audioPlayer!.delegate = self
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            } catch let error as NSError {
                print("audioPlayer error: \(error.localizedDescription)")
            }
        }
        
        PlayBtn.isEnabled = true
        RecordBtn.isEnabled = true
        
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        } else {
            audioPlayer?.stop()
        }
        
        
        if audioRecorder?.isRecording == false {
            RecordBtn.isEnabled = false
            
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: (audioRecorder?.url)!)
                audioPlayer!.delegate = self
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            } catch let error as NSError {
                print("audioPlayer error: \(error.localizedDescription)")
            }
        }
        
        

    }
    
    
    
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        RecordBtn.isEnabled = true
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio Play Decode Error")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Record Encode Error")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

