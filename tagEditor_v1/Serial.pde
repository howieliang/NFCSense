void serialEvent(Serial port) {   
  String inData = port.readStringUntil('\n');  // read the serial string until seeing a carriage return
  if (inData.charAt(0) >= 'A' && inData.charAt(0) <= 'D') {
    int i = inData.charAt(0)-'A';
    int v = int(trim(inData.substring(1)));
    rfid[i] = (v>255?-1:v);
    appendArray(idArray[i], rfid[i]);
  }
  return;
}
