# NFCSense
The Github Repository of the NFCSense Project

Project Website:
[https://ronghaoliang.page/NFCSense](https://ronghaoliang.page/NFCSense)

Rong-Hao Liang, Zengrong Guo, __NFCSense: Data-Defined Rich-ID Motion Sensing for Fluent Tangible Interaction Using a Commodity NFC Reader.__
In Proceedings of ACM CHI '21: CHI Conference on Human Factors in Computing Systems, Papeer 174, 14 pages, Yokohama, Japan, 

## Arduino Code
The arduino code is tested with an off-the-shelf 13.56 MHz NXP MFRC522 MIFARE HF RFID reader (Figure 2a) that supported ISO/IEC 14443 A/MIFARE tags. With the code, the NFC reader could achieve a max read rate of 311 tags/second with an Arduino Uno or Arduino Leonardo board. 
![Hardware Configuration](/figures/hardware.png)

We also informally tested an ESP32 board (Adafruit Huzzah 32) and Teensy boards (3.2 and 4.0). The example codes achieve a max read rate of ~250 tags/second on the ESP32 board and ~200 tags/second on the Teensy boards. Although the read rate is lower, they still can sufficiently support the motion sensing as presented in our paper.

## Dataset
The dataset (csv files) are the study results that we acquied using a A modifed delta 3D printer was used as a robotic arm holding the NFC tags. The data in each file is formatted as rows of 
- \[x,y,z,count]
where count is between 0 to 20. The detailed results can be found in the paper.