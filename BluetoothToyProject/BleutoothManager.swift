//
//  BleutoothManager.swift
//  BluetoothToyProject
//
//  Created by JinwooLee on 7/25/24.
//

import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, ObservableObject {
    @Published var isBluetoothEnabled = false
    @Published var receivedData: String = ""
    @Published var discoveredPeripherals = [CBPeripheral]()

    private var centralManager: CBCentralManager!

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isBluetoothEnabled = true
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            isBluetoothEnabled = false
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
        }
    }
    
    func toggleBluetooth() {
        if centralManager.state == .poweredOn {
            centralManager.stopScan()
            centralManager = nil
        } else {
            centralManager = CBCentralManager(delegate: self, queue: nil)
        }
    }
    
    func connect(to peripheral: CBPeripheral) {
        centralManager.stopScan()
        centralManager.connect(peripheral, options: nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            if let services = peripheral.services {
                for service in services {
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }

        func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
            if let characteristics = service.characteristics {
                for characteristic in characteristics {
                    if characteristic.properties.contains(.read) {
                        peripheral.readValue(for: characteristic)
                    }
                    if characteristic.properties.contains(.notify) {
                        peripheral.setNotifyValue(true, for: characteristic)
                    }
                }
            }
        }

        func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
            if let data = characteristic.value {
                let receivedString = String(data: data, encoding: .utf8) ?? "N/A"
                DispatchQueue.main.async {
                    self.receivedData = receivedString
                }
            }
        }
}
