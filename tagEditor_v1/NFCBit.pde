class NFCBit {
  final static int NA = 0;
  

  final static int BELOW_Z_STAR = 1;
  final static int ABOVE_Z_STAR = 2;
  final static int ABOVE_THETA_STAR = 3;
  
  final static int L_MOTION = 1;
  final static int ROTATION = 2;
  final static int SHM = 3;
  final static int COMPOUND_R1 = 4;
  final static int COMPOUND_R2 = 5;
  final static int COMPOUND_R3 = 6;
  final static int COMPOUND_L1 = 7;
  final static int COMPOUND_L2 = 8;

  int tokenType = 2;
  int motionType = 2;
  float[] l_onArray = new float[]{44};
  String[] stateStrArray = new String[]{"default"};

  ArrayList<Integer> profile = new ArrayList();
  int s=0;
  float r=0, t_I=0, t_M=0, f=0, V=0; 
  //boolean profileReady = false;

  NFCBit() {
    //apply all default settings
  }

  NFCBit(int tType, int mType) {
    tokenType = tType;
    motionType = mType;
  }

  NFCBit(int tType, int mType, float[] la, String[] sa) {
    tokenType = tType;
    motionType = mType;
    l_onArray = la;
    stateStrArray = sa;
  }

  //void getInfo(int s) {
  //  //implemented by the extended classes
  //}
  //void getFeatures(float l_on) {
  //  //implemented by the extended classes
  //}

  void setTokenType(int tType) {
    tokenType = tType;
  }
  void setMotionType(int mType) {
    motionType = mType;
  }
  void setL_onArray(float[] la) {
    l_onArray = la;
  }
  void setStateStrArray(String[] sa) {
    stateStrArray = sa;
  }

  float[] getL_onArray() {
    return l_onArray;
  }
  String[] getStateStrArray() {
    return stateStrArray;
  }
  int getTokenType() {
    return tokenType;
  }
  int getMotionType() {
    return motionType;
  }
}
