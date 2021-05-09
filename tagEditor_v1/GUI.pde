PFont font, font2;
int t_x = 20, t_y = 20;
int t_w = 300, t_w2=400, t_h = 80;
int u_s = 20, u_s2 = 50, u_s3 = 100;
Textlabel tl_ID_curr;
Textlabel tl_Info_curr;
Textlabel tl_ID_last;
Textlabel tl_name_curr;
Textlabel tl_tType;
Textlabel tl_mType;
Textlabel tl_lOn1;
Textlabel tl_lOn2;
Textlabel tl_info;
RadioButton rb_tType;
RadioButton rb_mType;
Numberbox nb_lOn1;
Numberbox nb_lOn2;
Button b_record;
Button b_export;
Button b_del;
ListBox tagList;
Textfield tf_name;
Textfield tf_filename;
color[] cl = {color(0), color(0, 125, 255), color(255), color(255, 100)};
String[] rbItems={"linear", "rotation", "S.H.M.", "comp-rot1", "comp-rot2", "comp-rot3", "comp-lin1", "comp-lin2"};
String[] mTypeItems={"", "LIN", "ROT", "SHM", "CR1", "CR2", "CR3", "CL1", "CL2"};
String[] tTypeItems={"", "Z<Z*", "Z>Z*", "T>T*", "D>D*"};
int lastTType=-1;
int lastMType=-1;

void initGUI() {

  cp5 = new ControlP5(this);
  font = createFont("Arial", 18);
  font2 = createFont("Arial", 12);
  textFont(font);

  tl_name_curr = cp5.addTextlabel("tagName").setText(tagName).setPosition(t_x+0*t_w, t_y+0*t_h).setColorValue(cl[2]).setFont(font);
  tl_ID_curr = cp5.addTextlabel("CurrTagID").setText("Current Tag UID:").setPosition(t_x+0*t_w, t_y+0.6*t_h).setColorValue(cl[3]).setFont(font);
  tl_Info_curr = cp5.addTextlabel("CurrTagInfo").setText("Current Tag Info:").setPosition(t_x+0*t_w, t_y+0.9*t_h).setColorValue(cl[3]).setFont(font);
  tl_ID_last = cp5.addTextlabel("LastTagID").setText("Last Tag UID: N/A").setPosition(t_x+0*t_w, t_y+1.2*t_h).setColorValue(cl[3]).setFont(font);
  tl_tType = cp5.addTextlabel("CurrTType").setText(tTypeString).setPosition(t_x+0*t_w, t_y+1.5*t_h).setColorValue(cl[2]).setFont(font);
  tl_mType = cp5.addTextlabel("CurrMType").setText(mTypeString).setPosition(t_x+0*t_w, t_y+2.5*t_h).setColorValue(cl[2]).setFont(font);
  tl_lOn1 = cp5.addTextlabel("CurrLOn1").setText(lOnString1).setPosition(t_x+0*t_w, t_y+3.5*t_h).setColorValue(cl[2]).setFont(font);
  tl_lOn2 = cp5.addTextlabel("CurrLOn2").setText(lOnString2).setPosition(t_x+0*t_w, t_y+4.*t_h).setColorValue(cl[2]).setFont(font);
  tl_info = cp5.addTextlabel("Info").setText("").setPosition(t_x+2*t_w-60, t_y+3.5*t_h).setColorValue(cl[2]).setFont(font);

  cp5 = new ControlP5(this);
  cp5.setFont(font2);
  Label.setUpperCaseDefault(false);
  tagList = cp5.addListBox("tagList") //
    .setPosition(t_x+2*t_w-60, t_y+0*t_h)
    .setSize(t_w2, (int)3.5*t_h)
    .setItemHeight(u_s)
    .setBarHeight(u_s)
    .setColorBackground(cl[0])
    .setColorActive(cl[1])
    .setColorForeground(cl[3])
    ;
  for (int i=0; i<12; i++) {
    tagList.addItem("", i);
  }
  rb_tType = cp5.addRadioButton("Token Type")
    .setLabel("Set Token Type")
    .setPosition(t_x+0.75*t_w, t_y+1.5*t_h)
    .setSize(u_s, u_s)
    .setColorForeground(cl[0])
    .setColorActive(cl[1])
    .setColorLabel(cl[2])
    .setItemsPerRow(2)
    .setSpacingColumn(85)
    .addItem("z<z*", 1)
    .addItem("z>z*", 2)
    .addItem("t>t*", 3)
    .addItem("d>d*", 4)
    .deactivateAll();

  rb_mType = cp5.addRadioButton("Motion Type")
    .setLabel("Set Motion Type")
    .setPosition(t_x+0.75*t_w, t_y+2.5*t_h)
    .setSize(u_s, u_s)
    .setColorForeground(cl[0])
    .setColorActive(cl[1])
    .setColorLabel(cl[2])
    .setItemsPerRow(3)
    .setSpacingColumn(85)
    .addItem("linear", 1)
    .addItem("rotation", 2)
    .addItem("S.H.M.", 3)
    .addItem("comp-rot1", 4)
    .addItem("comp-rot2", 5)
    .addItem("comp-rot3", 6)
    .addItem("comp-lin1", 7)
    .addItem("comp-lin2", 8)
    .deactivateAll();

  tf_name = cp5.addTextfield("tagName")
    .setLabel("Enter Tag Name")
    .setPosition(t_x+0.75*t_w, t_y+0*t_h)
    .setSize(u_s3, u_s)
    .setFocus(true)
    .setFont(font2)
    .setColor(cl[2]);

  tf_filename = cp5.addTextfield("fileName")
    .setLabel("Enter File Name (CSV)")
    .setPosition(t_x+2*t_w-60+u_s2*4, t_y+3.5*t_h)
    .setSize(u_s3, u_s)
    .setFocus(false)
    .setFont(font2)
    .setColor(cl[2])
    .setText(fileName);

  nb_lOn1=cp5.addNumberbox("l_on1")
    .setLabel("Set L_on1")
    .setPosition(t_x+0.75*t_w, t_y+3.5*t_h)
    .setSize(u_s3, u_s)
    .setRange(0, 100)
    .setMultiplier(0.1) // set the sensitivity of the numberbox
    .setDirection(Controller.HORIZONTAL) // change the control direction to left/right
    .setValue(l_on1)
    .setFont(font2)
    .setDecimalPrecision(0)
    ;
  nb_lOn2=cp5.addNumberbox("l_on2")
    .setLabel("Set L_on2")
    .setPosition(t_x+0.75*t_w, t_y+4*t_h)
    .setSize(u_s3, u_s)
    .setRange(0, 100)
    .setMultiplier(0.1) // set the sensitivity of the numberbox
    .setDirection(Controller.HORIZONTAL) // change the control direction to left/right
    .setValue(l_on2)
    .setFont(font2)
    .setDecimalPrecision(0)
    ;

  b_record=cp5.addButton("Add/Modify")
    .setValue(0)
    .setPosition(t_x+2*t_w-60, t_y+4*t_h)
    .setSize(u_s2+40, u_s)
    .setFont(font2)
    ;
  b_del=cp5.addButton("Remove Last")
    .setValue(1)
    .setPosition(t_x+2*t_w-60+u_s2*2, t_y+4*t_h)
    .setSize(u_s2+40, u_s)
    .setFont(font2)
    ;
  b_export=cp5.addButton("Export CSV")
    .setValue(2)
    .setPosition(t_x+2*t_w-60+u_s2*4, t_y+4*t_h)
    .setSize(u_s2+40, u_s)
    .setFont(font2)
    ;
  tTypeString = "Step 2: Set Token Type\n: ";
  //controlP5.addTextfield("label").setPosition(50, 50+60*4).setSize(120, U_H).setLabel("Label").setFont(font);
}

void updateGUI(long thisRead) {
  if (millis()-info_timer>3000) tl_info.setText("");
  tl_ID_curr.setText("Current Tag UID: "+decoder(thisRead));
  tl_Info_curr.setText("Current Tag Info: "+lastTagInfoString);
  if (lastTagInfoString!="") tl_Info_curr.setColor(cl[2]);
  else tl_Info_curr.setColor(cl[3]);
  if (lastRead>=0) tl_ID_last.setText("Last Tag UID: "+decoder(lastRead));
  tagName=cp5.get(Textfield.class, "tagName").getText();
  fileName=cp5.get(Textfield.class, "fileName").getText();
  tl_name_curr.setText("Step 1 - Set Tag Name\n: "+tagName);
  for (int n=0; n<1; n++) { 
    barGraph(idArray[n], 0, height, width, height/5, n);
  }
}

void saveGUIParams() { 
  tf_name.setFocus(true);
  l_on1 = nb_lOn1.getValue();
  l_on2 = nb_lOn2.getValue();
  lastMType=mType; 
  lastTType=tType;
}


void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(rb_tType)) {
    tType = (int)theEvent.getValue();
    switch(tType) {
    case 1: 
      nb_lOn1.show();//setVisible(true);
      tl_lOn1.show();//setVisible(true);
      nb_lOn2.show();//setVisible(true);
      tl_lOn2.show();//etVisible(true);
      for (int i=rbItems.length-1; i>=0; i--) {
        rb_mType.removeItem(rbItems[i]);
      }
      for (int i=0; i<1; i++) {
        rb_mType.addItem(rbItems[i], i+1);
      }
      rb_mType.activate(0);
      break;
    case 2:
      nb_lOn1.hide();//;
      tl_lOn1.hide();//
      nb_lOn2.hide();
      tl_lOn2.hide();
      for (int i=rbItems.length-1; i>=0; i--) {
        rb_mType.removeItem(rbItems[i]);
      }
      for (int i=0; i<3; i++) {
        rb_mType.addItem(rbItems[i], i+1);
      }
      rb_mType.deactivateAll();
      break;
    case 3:
      nb_lOn1.show();//
      tl_lOn1.show();//
      nb_lOn2.hide();
      tl_lOn2.hide();
      for (int i=rbItems.length-1; i>=0; i--) {
        rb_mType.removeItem(rbItems[i]);
      }
      for (int i=0; i<1; i++) {
        rb_mType.addItem(rbItems[i], i+1);
      }
      rb_mType.activate(0);
      break;
    case 4:
      nb_lOn1.hide();
      tl_lOn1.hide();
      nb_lOn2.hide();
      tl_lOn2.hide();
      for (int i=rbItems.length-1; i>=0; i--) {
        rb_mType.removeItem(rbItems[i]);
      }
      for (int i=3; i<rbItems.length; i++) {
        rb_mType.addItem(rbItems[i], i+1);
      }
      rb_mType.activate(0);
      break;
    }
    tTypeString = "Step 2: Set Token Type\n: "+getTTypeString(tType);
    tl_tType.setText(tTypeString);
  }
  if (theEvent.isFrom(rb_mType)) {
    mType = (int)theEvent.getValue();
    switch(mType) {
    case 1: 
      switch(tType) {
      case 1: 
        if (mType!=lastMType && tType!=lastTType) {
          l_on1=39.0; 
          l_on2=43.0;
        }
        lOnString1 = "Step 4-1: Set L_on1\n (sliding): "+nf(round(l_on1), 0)+" mm";
        lOnString2 = "Step 4-2: Set L_on2\n (hovering): "+nf(round(l_on2), 0)+" mm";
        nb_lOn1.show();//
        tl_lOn1.show();//
        nb_lOn2.show();
        tl_lOn2.show();
        break;
      case 2:
        if (mType!=lastMType && tType!=lastTType) {
          l_on1=43.0; 
          l_on2=0.0;
        }
        lOnString1 = "Step 4: Set L_on1\n (sliding)\n: "+nf(round(l_on1), 0)+" mm";
        nb_lOn1.show();//
        tl_lOn1.show();//
        nb_lOn2.hide();
        tl_lOn2.hide();
        break;
      case 3: 
        if (mType!=lastMType && tType!=lastTType) {
          l_on1=31.0; 
          l_on2=0.0;
        }
        lOnString1 = "Step 4: Set L_on1\n (sliding)\n: "+nf(round(l_on1), 0)+" mm";
        nb_lOn1.show();//
        tl_lOn1.show();//
        nb_lOn2.hide();
        tl_lOn2.hide();
        break;
      case 4: 
        if (mType!=lastMType && tType!=lastTType) {
          l_on1=0.0; 
          l_on2=0.0;
        }
        nb_lOn1.hide();//
        tl_lOn1.hide();//
        nb_lOn2.hide();
        tl_lOn2.hide();
        break;
      } 
      break;
    case 2:
      if (mType!=lastMType && tType!=lastTType) {
        l_on1=0.0; 
        l_on2=0.0;
      }
      nb_lOn1.hide();
      tl_lOn1.hide();
      nb_lOn2.hide();
      tl_lOn2.hide();
      break;
    case 3:
      if (mType!=lastMType && tType!=lastTType) {
        l_on1=0.0; 
        l_on2=0.0;
      }
      nb_lOn1.hide();//
      tl_lOn1.hide();//
      nb_lOn2.hide();
      tl_lOn2.hide();
      break;
    case 4:
      if (mType!=lastMType && tType!=lastTType) {
        l_on1=0.0; 
        l_on2=0.0;
      }
      nb_lOn1.hide();//
      tl_lOn1.hide();//
      nb_lOn2.hide();
      tl_lOn2.hide();
      break;
    case 5:
      if (mType!=lastMType && tType!=lastTType) {
        l_on1=0.0; 
        l_on2=0.0;
      }
      nb_lOn1.hide();//
      tl_lOn1.hide();//
      nb_lOn2.hide();
      tl_lOn2.hide();
      break;
    case 6:
      if (mType!=lastMType && tType!=lastTType) {
        l_on1=0.0; 
        l_on2=0.0;
      }
      nb_lOn1.hide();//
      tl_lOn1.hide();//
      nb_lOn2.hide();
      tl_lOn2.hide();
      break;
    case 7: 
      if (mType!=lastMType && tType!=lastTType) {
        l_on1=34.0;
        l_on2=0.0;
      }
      lOnString1 = "Step 4: Set Tag Distance\n(D_tag+d_gap)\n: "+nf(round(l_on1), 0)+" mm";
      nb_lOn1.show();//
      tl_lOn1.show();//
      nb_lOn2.hide();
      tl_lOn2.hide();
      break;
    case 8: 
      if (mType!=lastMType && tType!=lastTType) {
        l_on1=34.0;
        l_on2=0.0;
      }
      lOnString1 = "Step 4: Set Tag Distance\n(D_tag+d_gap)\n: "+nf(round(l_on1), 0)+" mm";
      nb_lOn1.show();//
      tl_lOn1.show();//
      nb_lOn2.hide();
      tl_lOn2.hide();
      break;
    }
    nb_lOn1.setValue(l_on1);
    nb_lOn2.setValue(l_on2);
    mTypeString = "Step 3: Set Motion Type\n: "+getMTypeString(mType);
    tl_mType.setText(mTypeString);
    tl_lOn1.setText(lOnString1);
    tl_lOn2.setText(lOnString2);
  }
  if (theEvent.isFrom(b_record)) {
    if (lastRead>=0) {
      if (mType==0 || tType==0) {
        tl_info.setText("Check the input data.");
        info_timer=millis();
      } else {
        bSave = true;
      }
    } else {
      tl_info.setText("Scan a tag first.");
      info_timer=millis();
    }
  }
  if (theEvent.isFrom(b_export)) {
    b_saveCSV = true;
  }
  if (theEvent.isFrom(b_del)) {
    bDel = true; 
    println("REMOVED LAST ONE");
  }
}
