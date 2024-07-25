//
//  ContentView.swift
//  BluetoothToyProject
//
//  Created by JinwooLee on 7/25/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var bluetoothManager = BluetoothManager() // this is Bluetooth manager
    
    var body: some View {
        VStack {
            Button(action: {
                bluetoothManager.toggleBluetooth()
            }) {
                Text(bluetoothManager.isBluetoothEnabled ? "Turn Off Bluetooth" : "Turn On Bluetooth")
                    .padding()
            }
            
            Text("Bluetooth is \(bluetoothManager.isBluetoothEnabled ? "enabled" : "disabled")")
                .padding()
            
            List(bluetoothManager.discoveredPeripherals, id: \.identifier) { peripheral in
                
                if let name = peripheral.name {
                    Text(name)
                        .onTapGesture {
                            bluetoothManager.connect(to: peripheral)
                        }
                }
            }
            
            Text("\(bluetoothManager.receivedData)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
