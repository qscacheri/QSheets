
Table table;
TableRow newRow;
String [] text = {""};
String a = "";
String [] temp;
String [] temp2;
int title = 0;
int info = 0;
boolean found = false;
String file;
boolean done = false;
PFont font;
int b1 = #4c0d72;
int b2 = #7422a5;
int b3 = b1;
String sessionName;
String trackName;
boolean named = false;
boolean finished = false;
String save;
boolean saveFound = false;
void setup() {
  PImage icon = loadImage("QSheets.png");
  surface.setIcon(icon);

  size(600, 600);
  pixelDensity(2);

  font = createFont("FOT-ChiaroStd-B.otf", 100);
}

void draw() {
  background(#ffffff);
  noFill();
  strokeWeight(8);  // Thicker

  stroke(#00aeef);
  rectMode(RADIUS);
  rect(300, 300, 300, 300);


  textFont(font);
  textSize(40); 
  //background(b3);

  fill(#00aeef);
  textAlign(CENTER);
  text("Click to Cue Sheet-ify", 300, 300);
  if (found && !done) {
    makeSheet(file);
    found = false;
    done = false;
  }

  if (finished) {
    textSize(15); 
    text("Finished with "+sessionName, 300, 350);
  }
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    file = selection.getAbsolutePath();
    found = true;
    println("User selected " + selection.getAbsolutePath());
  }
}

void mousePressed() {
  selectInput("Select a file to process:", "fileSelected");
  //println(mouseX+","+mouseY);
}

void makeSheet(String s) {

  println("found");
  table = new Table();
  table.addColumn("Track Name");

  table.addColumn("Region Name");
  table.addColumn("Start Time");
  table.addColumn("End Time");
  table.addColumn("Duration");
  saveTable(table, "data/new.csv");
  String[] lines = loadStrings(s);
  int x = 0;
  for (int i = 0; i< lines.length; i++) {    

    if (lines[i].length()!=0) {
      lines[i]=lines[i].replaceAll("\t", "  ");
      lines[i]=lines[i].replaceAll("\\s{2,}+", "&");
      lines[i]=lines[i].replaceAll("\n", "");
      lines[i]=lines[i].replaceAll("\r", "");
      temp = lines[i].split("&");
      text = concat(text, temp);
    }
  }
  for (int i = 0; i<text.length; i++) {
    if (text[i].equals("SESSION NAME:")) {
      sessionName = text[i+1];
    }

    if (text[i].equals("TRACK NAME:")) { 
      println("Track Name: "+ text[i+1]);
      trackName = text[i+1];
      named = false;
    }
    if (text[i].equals("STATE")) {
      if (text[i-1].equals("DURATION")) {
        info = i+1;
        a = text[info];
        x = 1; 
        //println(a);
        while (Character.isDigit(a.charAt(0))) {
          newRow = table.addRow(); 
          if (!named) {
            newRow.setString("Track Name", trackName);
            named = true;
          } else newRow.setString("Track Name", "");
          newRow.setString("Region Name", text[info+2]);
          newRow.setString("Start Time", text[info+3]);
          newRow.setString("End Time", text[info+4]);
          newRow.setString("Duration", text[info+5]);

          //println(Integer.parseInt(a));
          println("Region Name: "+text[info+2]);
          println("Start Time: "+text[info+3]);
          println("End Time: "+text[info+4]);
          println("Duration: "+text[info+5]);
          info+=7;
          a = text[info+1];
        }
        println("\n\n");
      }
    }
  }
  println(sessionName);
  selectFolder("Where do you want to save?", "folderSelected");
  while(saveFound==false){println("not found");}
  println("found save");
  saveTable(table, save);
  saveFound = false;

  done = true;
  finished = true;
}


void folderSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    save = selection.getAbsolutePath()+"/"+sessionName+"_Cue_Sheet.csv";
    saveFound = true;
    println("User selected " + save);
  }
}
