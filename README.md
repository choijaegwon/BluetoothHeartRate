# BluetoothHeartRate
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

# 출처
https://www.bluetooth.com/specifications/assigned-numbers/  
https://www.kodeco.com/231-core-bluetooth-tutorial-for-ios-heart-rate-monitor