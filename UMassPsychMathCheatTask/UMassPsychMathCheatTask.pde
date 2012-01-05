import controlP5.*;

/* =Interface
-------------------------------*/

ControlP5 cp5;

ControlGroup introG;
ControlGroup trialG;
ControlGroup doneG;

Textarea introText;
Textarea doneText;

Textlabel eqLabel;
Textlabel rightLabel;
Textlabel wrongLabel;

Textfield answerText;
Button submitButton;

color BG_COLOR = color(250, 250, 250);
color RIGHT_COLOR = color(31, 95, 31);
color WRONG_COLOR = color(255, 0, 0);
color IF_BG = color(236, 236, 236);
color IF_FG = color(220, 220, 220);
color IF_LABEL = color(0, 0, 0);
color IF_VALUE = color(0, 0, 0);
color IF_ACTIVE = color(232, 47, 47);

/* =Experiment
-------------------------------*/

final int INTRO = 0;
final int PRACTICE = 1;
final int EXPERIMENT = 2;
final int DONE = 3;
int thisState = INTRO;

String dataFilePath;
PrintWriter out;

void setup() {
  // set up app window
  size(400, 400);
  frameRate(25);

  // create interface
  cp5 = new ControlP5(this);

  cp5.setColorForeground(IF_FG);
  cp5.setColorBackground(IF_BG);
  cp5.setColorLabel(IF_LABEL);
  cp5.setColorValue(IF_VALUE);
  cp5.setColorActive(IF_ACTIVE);

  introG = cp5.addGroup("intro", 0, 0, 400);
  introText = cp5.addTextarea("introText", "INTRO TEXT HERE", 0, 0, 400, 400);
  introText.setGroup("intro");

  trialG = cp5.addGroup("trial", 0, 0, 400);
  eqLabel = cp5.addTextlabel("equation", "++++++++++", 0, 50);
  eqLabel.setColorValue(IF_VALUE);
  rightLabel = cp5.addTextlabel("right", "Correct", 0, 20);
  rightLabel.setColorValue(RIGHT_COLOR);
  wrongLabel = cp5.addTextlabel("wrong", "Incorrect - Please Try Again", 0, 20);
  wrongLabel.setColorValue(WRONG_COLOR);
  answerText = cp5.addTextfield("answer", 0, 80, 35, 20);
  submitButton = cp5.addButton("submit", 0, 50, 80, 50, 20);
  rightLabel.hide();
  wrongLabel.hide();
  eqLabel.setGroup("trial");
  rightLabel.setGroup("trial");
  wrongLabel.setGroup("trial");
  answerText.setGroup("trial");
  submitButton.setGroup("trial");

  doneG = cp5.addGroup("done", 0, 0, 400);
  doneText = cp5.addTextarea("doneText", "DONE TEXT HERE", 0, 0, 400, 400);
  doneText.setGroup("done");

  // start intro interface
  doIntro();
}

void draw() {
  background(BG_COLOR);
}

// answer textfield event handler
// check submitted answer, inform subject, continue or repeat if right/wrong
public void textAnswer(String val) {
  println("answer submitted : "+ val);
}

// cheat keypress handler
// show answer once space bar is pressed
public void keyPressed() {
  switch (thisState) {
    case INTRO:
      if (key == ' ') {
        doPractice();
        println("start practice");
      }
      break;

    case PRACTICE:
      if (key == ' ') {
        doExperiment();
        println("start experiment");
      }
      break;

    case EXPERIMENT:
      if (key == ' ') {
        println("cheat");
      }
      break;

    case DONE:
      if (key == ' ') {
        out.flush();
        out.close();
        exit();
      }
      break;
  }
}

// do intro
void doIntro() {
  // select output file for experiment data
  dataFilePath = selectOutput();
  if (dataFilePath == null)
    exit();
  else
    out = createWriter(dataFilePath);

  // start intro
  showIntro();
  thisState = INTRO;
}

// do practice
void doPractice() {
  showTrial();
  thisState = PRACTICE;
}

// do experiment
void doExperiment() {
  showTrial();
  thisState = EXPERIMENT;
}

// do conclusion
void doConclusion() {
  showConclusion();
  thisState = DONE;
}

// show intro
void showIntro() {
  introG.show();
  trialG.hide();
  doneG.hide();
}

// show answer interface
void showTrial() {
  introG.hide();
  trialG.show();
}

// show conclusion
void showConclusion() {
  trialG.hide();
  doneG.show();
}