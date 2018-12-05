module Visualization

import vis::KeySym;
import vis::Figure;
import vis::Render;

import TypeOneDuplication;
import Count;
import Read;
import List;
import IO;

public void showClassFigure(){
loc smallsql = |project://smallsql0.21_src|;
showClasses(smallsql);
}


public void showClasses(loc projectLocation){
list[loc] files = getFiles(projectLocation);

list[Figure] boxes = [];
for(loc file <- files){ 
getDuplicateLinesPerProject(getLoc(file));

Color colorBox;
if(typeOne.lines == 0){
colorBox = rgb(161, 224, 53);
}
else if (typeOne.lines <30){
colorBox = rgb(236, 239, 26);
}
else {
colorBox = rgb(226, 32, 22);
}

boxes += box(text(file.path),fillColor(colorBox)); // Todo: adapt colours to duplication level
}
b2 = box(vcat(boxes));
render(b2);
}



public void showButton(){
  int n = 0;
  butt = vcat([ button("Increment", void(){n += 1;}),
                text(str(){return "<n>";})
              ]);

render(butt);
}
public void visDuplicationClasses(){
loc smallSQL = |project://smallsql0.21_src/src|;
lines = getProjectLoc(smallSQL);
duplBlocks = getDuplicateBlocks (lines);
map[str,list[list[int]]] mapDuplications = duplBlocks.mapDupl;
}


public void testThat(){
s = "";
s2 = "";
b = box(text(str () { return s; }),
	fillColor("red"),
	onKeyDown(bool (KeySym key, map[KeyModifier,bool] modifiers) {
		s = "<key>";
		return true;
	}));
b2 = box(vcat([
	text(str () { return s2; }),
	b],shrink(0.7)),
	fillColor("green"),
	onKeyDown(bool (KeySym key, map[KeyModifier,bool] modifiers) {
		s2 = "<key>";
		return true;
	}));
render(b2);
}

public void showFigure(){
figureToShow = box([size(1), fillColor(rgb(25,25,112))]);
render(figureToShow);
}