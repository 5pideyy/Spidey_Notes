## LM35 Temperature Sensor
- voltage output that is linearly proportional to the temperature in °C
- requires a negative bias voltage to measure negative temperature (disadvan)

![[Pasted image 20240723220042.png]]
+Vs =>input 4V to 30V 
Vout => produces analog voltage


# DHT11
- inside DHT11 =>NTC thermistor
- digital output
- external 10K pull-up resistor on the output (in bult)

![[Pasted image 20240723220529.png]]


+Vcc =>3.3V to 5.5V


|   |   |   |
|---|---|---|
||![DHT11 Temperature Humidity Sensor Fritzing part Illustration](https://lastminuteengineers.com/wp-content/uploads/arduino/DHT11-Temperature-Humidity-Sensor-Fritzing-part-Illustration.png)|![DHT22 Temperature Humodoty Sensor Fritzing part Illustration](https://lastminuteengineers.com/wp-content/uploads/arduino/DHT22-Temperature-Humidity-Sensor-Fritzing-part-Illustration.png)|
||DHT11|DHT22|
|Operating Voltage|3 to 5V|3 to 5V|
|Max Operating Current|2.5mA max|2.5mA max|
|Humidity Range|20-80% / 5%|0-100% / 2-5%|
|Temperature Range|0-50°C / ± 2°C|-40 to 80°C / ± 0.5°C|
|Sampling Rate|1 Hz (reading every second)|0.5 Hz (reading every 2 seconds)|
|Body size|15.5mm x 12mm x 5.5mm|15.1mm x 25mm x 7.7mm|
|Advantage|Ultra low cost|More Accurate|


![[Pasted image 20240723220800.png]]







- Use the **LM35** if you only need temperature measurements and prefer an analog output.
- Use the **DHT11** if you need both temperature and humidity measurements and prefer a digital output.


# Q FLAG IN ASPR

- during arithmetic operation when the result limit exeeds(exceeds boundary conditions, fall into negative region,overflow occurs)
- Q flag is set and the result is clamped to maximum value
- sticky not changed , only changed using MSR (move to special register) instruction
-  `MSR APSR_nzcvq, #0  ; Clear the Q flag`

# STR Register

- store contents of a register into memory location to a specific address 

```
STR <Rt>, [<Rn>, #<imm>]
- `<Rt>` is the register containing the data to be stored.
- `<Rn>` is the base register containing the address of the memory location.
- `#<imm>` is an optional immediate offset (which can be positive or negative).
```

