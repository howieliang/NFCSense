/*========================================================================== 
 //  OpenNFCSense4P (v1) - Open NFCSense API for Processing Language
 //  Copy cv right (C) 2021 Dr. Rong-Hao Liang
 //    This program is free software: you can redistribute it and/or modify
 //    it under the terms of the GNU General Public License as published by
 //    the Free Software Foundation, either version 3 of the License, or
 //    (at your option) any later version.
 //
 //    This program is distributed in the hope that it will be useful,
 //    but WITHOUT ANY WARRANTY; without even the implied warranty of
 //    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 //    GNU General Public License for more details.
 //
 //    You should have received a copy of the GNU General Public License
 //    along with this program.  If not, see <https://www.gnu.org/licenses/>.
 //==========================================================================*/
// TagEditor.pde v1 (dependency: controlp5)
// This software works with a microcontroller running Arduino code and connected to an RC522 NFC/RFID Reader
// Github repository: https://github.com/howieliang/NFCSense
// Project website: https://ronghaoliang.page/NFCSense/

import controlP5.*;
import processing.serial.*;
Serial port;
ControlP5 cp5;

int IDBitNum = 5;
int[] rfid = new int[IDBitNum];
ArrayList<NFCBit> al = new ArrayList<NFCBit>();
ArrayList<Long> id_db = new ArrayList<Long>();

int[] rawData;
int sensorNum = 1;
int dataNum = 50;

Table csvData;
String fileName = "myLegoData.csv";
boolean b_saveCSV = false;

int label = 0;


int U_W = 44, U_H = 24; 
int mType = 1;
int tType = 1;
float l_on1 = 43.0, l_on2 = 39.0;

String tagName = "";
String tTypeString = "Token Type: ", mTypeString = "Motion Type: ", lOnString1 = "L1: ", lOnString2 = "L2: ";

int streamSize = 300;
float[][] idArray = new float[IDBitNum][streamSize];


int cnt = 0;
long lastRead = -1;
int lastIndex = -1;
boolean bSave = false;
boolean bDel = false;
int selectIndex = 0;
long info_timer = millis();
String lastTagInfoString = "";
void setup() {
  size(1000, 500);
  initGUI();

  csvData = loadTable(fileName, "header");
  if (csvData==null) {
    println("Previous profile not found.");
    //Initiate the dataList and set the header of table
    csvData = new Table();
    csvData.addColumn("UID0");
    csvData.addColumn("UID1");
    csvData.addColumn("UID2");
    csvData.addColumn("UID3");
    csvData.addColumn("Label");
    csvData.addColumn("Ttype"); //z<z*, z>z*, t>t*, d>d*
    csvData.addColumn("Mtype"); //ltrans, rot, shm  
    csvData.addColumn("L1");
    csvData.addColumn("L2");
  } else {
    int n = csvData.getRowCount();
    for (int r = 0; r < n; r++) {
      TableRow newRow = csvData.getRow(r);
      int uid0 = newRow.getInt("UID0");
      int uid1 = newRow.getInt("UID1");
      int uid2 = newRow.getInt("UID2");
      int uid3 = newRow.getInt("UID3");
      String tagName = newRow.getString("Label");
      int tType = newRow.getInt("Ttype");
      int mType = newRow.getInt("Mtype");
      float lon1 = newRow.getFloat("L1");
      float lon2 = newRow.getFloat("L2");
      int[] _rfid = {uid0, uid1, uid2, uid3};
      id_db.add( IDtoLong(_rfid) );
      lastIndex = id_db.size()-1;
      NFCBit nb = new NFCBit(tType, mType, new float[] {lon1, lon2}, new String[] {tagName});
      al.add(nb);

      refreshTagList();
    }
  }
  //Initiate the serial port
  rawData = new int[sensorNum];
  for (int i = 0; i < Serial.list().length; i++) println("[", i, "]:", Serial.list()[i]);
  String portName = Serial.list()[Serial.list().length-1];//MAC: check the printed list
  //String portName = Serial.list()[0];//WINDOWS: check the printed list
  port = new Serial(this, portName, 115200);
  port.bufferUntil('\n'); // arduino ends each data packet with a carriage return 
  port.clear();           // flush the Serial buffer
}

int counter =0;
long prevRead = -1;
void draw() {
  background(52);

  long thisRead = IDtoLong(rfid);
  if (thisRead>=0) {
    if (thisRead != prevRead) { 
      counter=0;
      prevRead = thisRead;
    }
    ++counter;
    if (counter>1)lastRead = thisRead;
  }
  if (id_db.size()>=0) { //if the ID is in the list, call the history
    int searchDB = searchID (id_db, thisRead);
    if (searchDB>=0) { 
      lastTagInfoString = getInfoString(searchDB);
    } else {
      lastTagInfoString="";
    }
  }
  updateGUI(thisRead);

  if (bSave) {
    int searchResult = searchID (id_db, lastRead); 
    int index = saveID(lastRead, searchResult);
    refreshTagList();
    tl_info.setText("Recorded: "+(index+1));
    saveGUIParams();
    info_timer = millis();
    bSave = false;
  }

  if (bDel) {
    if (id_db.size()>0) {
      id_db.remove(lastIndex);
      al.remove(lastIndex);
      lastIndex = id_db.size()-1;
      refreshTagList();
      tl_info.setText("Last item removed. Remaining: "+lastIndex);
      info_timer=millis();
    }
    bDel=false;
  }

  if (b_saveCSV) {
    csvData.clearRows();
    for (int i = 0; i < id_db.size(); i++) {
      Long id = id_db.get(i);
      NFCBit nb = al.get(i);
      TableRow newRow = csvData.addRow();
      newRow.setInt("UID0", (int)(id/(256*256*256))%256); 
      newRow.setInt("UID1", (int)(id/(256*256))%256);
      newRow.setInt("UID2", (int)(id/(256))%256);
      newRow.setInt("UID3", (int)(id%256));
      newRow.setString("Label", nb.stateStrArray[0]);
      newRow.setInt("Ttype", nb.tokenType);
      newRow.setInt("Mtype", nb.motionType);
      newRow.setFloat("L1", floor(nb.l_onArray[0]));
      newRow.setFloat("L2", floor(nb.l_onArray[1]));
    }

    //Save the table to the file folder
    saveTable(csvData, "data/"+fileName); //save table as CSV file
    tl_info.setText("Saved as: "+fileName);
    info_timer=millis();
    b_saveCSV = false;
  }
}
