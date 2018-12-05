module Visualization

import vis::KeySym;
import vis::Figure;
import vis::Render;

import TypeOneDuplication;
import Count;
import Read;
import List;
import IO;
import Helper;
import Map;

map[str, list[list[LineType]]] duplWholeFile;

public void showClassFigure(){
	loc smallsql = |project://smallsql0.21_src|;
	duplWholeFile = getDuplicateLinesPerProject(getProjectLoc(smallsql));
	showClasses(smallsql);
}

//overview classes
public void showClasses(loc projectLocation){
	list[loc] files = getFiles(projectLocation);
	list[Figure] boxes = [];
	
	for(loc file <- files){ 
		duplForFiles = getDuplicateLinesPerProject(getLoc(file)); // REDO: done to set typeOne in Class TypeOneDuplcation
		boxes += box(text(file.path),
				fillColor(getColorForDuplRating()),
				onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
					showDuplicates(duplForFiles); //show details
					return true;
				}));
	}
	
	b2 = box(vcat(boxes));
	render(b2);
}

//show duplicates on class level
public void showDuplicates(map[str block, list[list[LineType]] mapOfDuplLines] dupl){
list[Figure] boxes = [];

for (str duplText <- dupl){
	
	// find all lines where the block "duplText" appears
	list[int] occurences = [];
	for(list[LineType] occLine <- dupl[duplText]){
		for(LineType typeL <- occLine){
			occurences += typeL.index;
		}
	}
	

	boxes += box(
				
				text(duplText + "\n lines: " + toString(occurences)),
 				
 				onKeyDown(bool (KeySym key, map[KeyModifier,bool] modifiers) {
				showClassFigure(); //go back to overview
				return true;
				}),
				
				onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
				showDuplicatesInOtherFiles(duplText); //TODO
				return true;
				})
				
				);
}

 render(box(vcat(boxes)));
}

// show all occurences of the block duplicateText
public void showDuplicatesInOtherFiles(str duplicateText){
	list[Figure] boxes = [];
	
	for (list[LineType] listOfOcc <- duplWholeFile[duplicateText]){
		loc locat = listOfOcc[0].file;
		boxes += box(text(locat.path), //TODO: add line numbers
		
				onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
				showClassFigure(); //go back to overview
				return true;
				}));
	}
	render(box(vcat(boxes)));


}

// TODO: adapt boundaries and take the number of duplicates contained in the file
public Color getColorForDuplRating(){
	if(typeOne.lines == 0){
		return rgb(161, 224, 53);
	}
	else if (typeOne.lines <30){
		return rgb(236, 239, 26);
	}
	else {
		return rgb(226, 32, 22);
	}
}


public void showButton(){
  int n = 0;
  butt = vcat([ button("Increment", void(){n += 1;}),
                text(str(){return "<n>";})
              ]);

render(butt);
}


public void testThat(){
s = "Hellooo";
s2 = "ucweui";
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