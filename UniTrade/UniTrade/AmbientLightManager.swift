//
//  AmbientLightManager.swift
//  UniTrade
//
//  Created by Federico Melo on 30/09/24.
//

import SensorKit
import SwiftUI

class AmbientLightManager: NSObject, ObservableObject, SRSensorReaderDelegate {
    @Published var isDarkMode: Bool = false

    private let sensorReader = SRSensorReader(sensor: .ambientLightSensor)

    override init() {
        super.init()
        sensorReader.delegate = self
        requestAmbientLightAuthorization()
    }

    func requestAmbientLightAuthorization() {
        guard sensorReader.authorizationStatus == .notDetermined else {
            print("Authorization already requested or granted.")
            return
        }

        SRSensorReader.requestAuthorization(sensors: [.ambientLightSensor]) { [weak self] error in
            if let error = error {
                if (error as NSError).code == 4 {
                    print("User declined the sensor authorization prompt.")
                    DispatchQueue.main.async {
                        self?.isDarkMode = false
                    }
                } else {
                    print("Sensor authorization failed due to: \(error)")
                }
            } else {
                if self?.sensorReader.authorizationStatus == .authorized {
                    print("Authorization granted")
                    self?.startRecordingAmbientLight()
                } else {
                    print("Awaiting user authorization or authorization denied.")
                }
            }
        }
    }

    func startRecordingAmbientLight() {
        guard sensorReader.authorizationStatus == .authorized else {
            print("Not authorized to access ambient light sensor.")
            return
        }
        sensorReader.startRecording()
        print("Started recording ambient light sensor data.")
    }

    func stopRecordingAmbientLight() {
        sensorReader.stopRecording()
        print("Stopped recording ambient light sensor data.")
    }

    func sensorReader(_ sensorReader: SRSensorReader, didFetchResult result: Any) {
        if let samples = result as? [SRAmbientLightSample] {
            processAmbientLightSamples(samples)
        }
    }

    private func processAmbientLightSamples(_ samples: [SRAmbientLightSample]) {
        for sample in samples {
            let luxValue = sample.lux.value
            print("Current ambient light level: \(luxValue) lux")
            if luxValue < 100 {
                DispatchQueue.main.async {
                    self.isDarkMode = true
                }
            } else {
                DispatchQueue.main.async {
                    self.isDarkMode = false
                }
            }
        }
    }
}
