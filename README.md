# BluetoothHeartRate
## 기본적인 구조
---
![image](https://user-images.githubusercontent.com/68246962/233295982-a58b9fc6-6b97-4228-b720-2838afdf85b7.png)

## 권한 요청
Info.plist
~~~
Privacy - Bluetooth Always Usage Description
~~~
---

## 심박계 블루투스 UUID
~~~
let heartRateServiceCBUUID = CBUUID(string: "0x180D")
~~~
---
## 심박수 측정 UUID
~~~
let heartRateMeasurementCharacteristicCBUUID = CBUUID(string: "2A37")
~~~
---
## 심박계 위치 UUID
~~~
let bodySensorLocationCharacteristicCBUUID = CBUUID(string: "2A38")
~~~

# Reference
https://www.bluetooth.com/specifications/assigned-numbers/   
https://learn.adafruit.com/build-a-bluetooth-app-using-swift-5?view=all    
https://www.kodeco.com/231-core-bluetooth-tutorial-for-ios-heart-rate-monitor
