//
//  HRMViewModel.swift
//  BLEHeartRate
//
//  Created by Jae kwon Choi on 2023/04/15.
//

import CoreBluetooth
import Foundation

class HRViewModel: NSObject, CBCentralManagerDelegate, ObservableObject {

    /// 블투투스 통신을 위한 매니저
    private var centralManager: CBCentralManager!
    /// 삼박계 전용 UUID
    private let heartRateServiceCBUUID = CBUUID(string: "0x180D")
    /// 심박계 장치
    private var heartRatePeripheral: CBPeripheral!
    /// 심박수측정
    private let heartRateMeasurementCharacteristicCBUUID = CBUUID(string: "2A37")
    /// 심박계 위치
    private let bodySensorLocationCharacteristicCBUUID = CBUUID(string: "2A38")
    /// 심박계 위치 화면에 표시
    @Published var BLElocation: String = "Other"
    /// 심박수 표시
    @Published var BLEHeartRate: Int = 0
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    /// central은 블투수트 통신 받을 객체
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            self.centralManager.scanForPeripherals(withServices: [self.heartRateServiceCBUUID])
        @unknown default:
            fatalError()
        }
    }

    /// 주변 기기를 찾기
    func centralManager(
        _: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData _: [String: Any],
        rssi _: NSNumber
    ) {
        print(peripheral)
        /// 찾은 장치를 변수에 저장
        self.heartRatePeripheral = peripheral
        /// 스캔을 멈추고
        self.centralManager.stopScan()
        /// 연결을 해주기
        self.centralManager.connect(self.heartRatePeripheral)
    }

    /// 심박계가 연결됐는지 확인하기
    func centralManager(_: CBCentralManager, didConnect _: CBPeripheral) {
        print("연결 성공!")
        self.heartRatePeripheral.discoverServices([self.heartRateServiceCBUUID])
        self.heartRatePeripheral.delegate = self
    }
}

// MARK: CBPeripheralDelegate

extension HRViewModel: CBPeripheralDelegate {

    /// service 검색에 성공 시 호출되는 메서드
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices _: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    /// characteristic 검색에 성공 시 호출되는 메서드
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error _: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            if characteristic.properties.contains(.read) {
                /// 심박계 위치 정보 읽기
                print("\(characteristic.uuid): properties contains .read")
                peripheral.readValue(for: characteristic)
                
            }
            if characteristic.properties.contains(.notify) {
                /// 심박수가 측정 될때마다 알람
                print("\(characteristic.uuid): properties contains .notify")
                peripheral.setNotifyValue(true, for: characteristic)
                
            }
            
        }
    }
    
    func peripheral(_: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error _: Error?) {
        switch characteristic.uuid {
        case self.bodySensorLocationCharacteristicCBUUID:
            let bodySensorLocation = self.bodyLocation(from: characteristic)
            self.BLElocation = bodySensorLocation
        case self.heartRateMeasurementCharacteristicCBUUID:
            let BLEHeartRate = self.heartRate(from: characteristic)
            self.BLEHeartRate = BLEHeartRate
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }

    /// 심박계 위치 정보
    private func bodyLocation(from characteristic: CBCharacteristic) -> String {
        guard let characteristicData = characteristic.value,
              let byte = characteristicData.first else { return "Error" }

        switch byte {
        case 0: return "Other"
        case 1: return "Chest"
        case 2: return "Wrist"
        case 3: return "Finger"
        case 4: return "Hand"
        case 5: return "Ear Lobe"
        case 6: return "Foot"
        default:
            return "Reserved for future use"
        }
    }

    /// 심박수 정보
    private func heartRate(from characteristic: CBCharacteristic) -> Int {
        guard let characteristicData = characteristic.value else { return -1 }
        let byteArray = [UInt8](characteristicData)

        let firstBitValue = byteArray[0] & 0x01
        if firstBitValue == 0 {
            // 심박수 값 형식이 2번쨰 바이트에 있을 때
            return Int(byteArray[1])
        } else {
            // 심박수 값 형식이 2번째 와 3번쨰에 바이트에 있을 때
            return (Int(byteArray[1]) << 8) + Int(byteArray[2])
        }
    }

}
