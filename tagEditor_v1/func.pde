int searchID (ArrayList<Long> id_db, long id) {
  int index = -1;
  if (id>=0) {
    for (int i=0; i<id_db.size(); i++) {
      if (id_db.get(i) == id) {
        index = i;
        break;
      }
    }
  } else {
    index = -2;
  }
  return index;
}

String getTTypeString(int tType) {
  String str = "";
  switch(tType) {
  case 1: 
    str  = "z<z*"; 
    break;
  case 2: 
    str  = "z>z*"; 
    break;
  case 3: 
    str  = "theta>theta*"; 
    break;
  case 4: 
    str  = "d_gap<d_gap*"; 
    break;
  }
  return str;
}

String getMTypeString(int mType) {
  String str ="";
  switch(mType) {
  case 1: 
    str  = "linear translation"; 
    break;
  case 2: 
    str  = "rotation"; 
    break;
  case 3: 
    str  = "simple harmonic motion"; 
    break;
  case 4: 
    str  = "compound rotation-1"; 
    break;
  case 5: 
    str  = "compound rotation-2"; 
    break;
  case 6: 
    str  = "compound rotation-3";
    break;
  case 7: 
    str  = "compound linear-1"; 
    break;
  case 8: 
    str  = "compound linear-2";
    break;
  }
  return str;
}

long IDtoLong(int[] b) {
  return (long)b[0]*256*256*256+(long)b[1]*256*256+(long)b[2]*256+(long)b[3];
}

String decoder(long l) {
  return (l/(256*256*256))%256+","+(l/(256*256))%256+","+(l/(256))%256+","+l%256;
}

void refreshTagList() {
  tagList.clear();
  for (int i = 0; i < id_db.size(); i++) {
    NFCBit n = al.get(i);
    String infoString = (i+1)+". Name="+n.stateStrArray[0]+"["+decoder(id_db.get(i))+"]:T="+tTypeItems[n.tokenType]+",M="+mTypeItems[n.motionType];
    switch(n.motionType) {
    case NFCBit.L_MOTION: 
      switch(n.tokenType) {
      case NFCBit.BELOW_Z_STAR: 
        infoString+=",L1="+floor(n.l_onArray[0])+",L2="+floor(n.l_onArray[1]); 
        break;
      case NFCBit.ABOVE_Z_STAR: 
        infoString+=",L1="+floor(n.l_onArray[0]); 
        break;
      case NFCBit.ABOVE_THETA_STAR: 
        infoString+=",L1="+floor(n.l_onArray[0]); 
        break;
      }
      break;
    case NFCBit.COMPOUND_L1: 
      infoString+="/D="+floor(n.l_onArray[0]); 
      break;
    case NFCBit.COMPOUND_L2: 
      infoString+="/D="+floor(n.l_onArray[0]); 
      break;
    }
    tagList.addItem(infoString, i);
  }
  for (int i=0; i<(12-id_db.size()); i++) {
    tagList.addItem("", i);
  }
}

String getInfoString(int index) {
  String infoString = "";
  NFCBit n = al.get(index);
  infoString +="["+n.stateStrArray[0]+"]:T="+tTypeItems[n.tokenType]+",M="+mTypeItems[n.motionType];
  switch(n.motionType) {
  case NFCBit.L_MOTION: 
    switch(n.tokenType) {
    case NFCBit.BELOW_Z_STAR: 
      infoString+=",L1="+floor(n.l_onArray[0])+",L2="+floor(n.l_onArray[1]); 
      break;
    case NFCBit.ABOVE_Z_STAR: 
      infoString+=",L1="+floor(n.l_onArray[0]); 
      break;
    case NFCBit.ABOVE_THETA_STAR: 
      infoString+=",L1="+floor(n.l_onArray[0]); 
      break;
    }
    break;
  case NFCBit.COMPOUND_L1: 
    infoString+="/D="+floor(n.l_onArray[0]); 
    break;
  case NFCBit.COMPOUND_L2: 
    infoString+="/D="+floor(n.l_onArray[0]); 
    break;
  }
  return infoString;
}

int saveID(long lastRead, int searchResult) {
  int index = -1;
  if (searchResult == -1) { // tag not found
    //add that in the history
    id_db.add(lastRead);
    lastIndex = id_db.size()-1;
    NFCBit n = new NFCBit(tType, mType, new float[] {l_on1, l_on2}, new String[] {tagName});
    al.add(n);
    index = lastIndex;
  }
  if (searchResult >= 0) {
    NFCBit nb = new NFCBit(tType, mType, new float[] {l_on1, l_on2}, new String[] {tagName});
    al.set(searchResult, nb);
    index = searchResult;
  }
  return index;
}
