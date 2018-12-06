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
	
		duplForFile = filterForFile(file);
		filepath = file.path; //has to be done like this, otherwise last element of files is taken
		
		boxes += box(text(file.path),
				fillColor(getColorForDuplRating(duplForFile)),
				onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
					showDuplicates(duplForFile,filepath); //go to new view which shows details
					return true;
				}));
	}
	
	b2 = box(vcat(boxes));
	render(b2);
}

public map[str, list[list[LineType]]] filterForFile(loc fileLoc){

map[str, list[list[LineType]]] mapDupl = ();

for(str text <- duplWholeFile){
	for(list[LineType] lines <- duplWholeFile[text]){
		if(lines[0].file.path == fileLoc.path){
			//if in map add value otherwise add key and values
			if(text in mapDupl){
				mapDupl[text] += [lines];
				}
			else{
				mapDupl += (text:[lines]);
			}
		}
		
	}
	
}
return mapDupl; 
}

//show duplicates on class level TODO: Um welche Datei handelt es sich
public void showDuplicates(map[str block, list[list[LineType]] mapOfDuplLines] duplPerFile, str filepath){
list[Figure] boxes = [box(text(filepath))];

for (str duplText <- duplPerFile){
	
	// find all lines where the block "duplText" appears
	textDup = duplText;
	occurences = "";
	
	
	for(list[LineType] occLine <- duplPerFile[duplText]){
			occurences += "line: <occLine[0].index>  -  <occLine[5].index>, ";
	}
	

	boxes += box(
				
				hcat([	text("duplicated Block "  + "\n \n appears in lines: ", fontColor("blue"), align(0,0) ), 
						text(textDup + "\n \n" + occurences, align(0, 0))]),
 				
 				onKeyDown(bool (KeySym key, map[KeyModifier,bool] modifiers) {
				showClassFigure(); //go back to overview
				return true;
				}),
				
				onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
				showDuplicatesInOtherFiles(textDup, filepath); //TODO
				return true;
				})
				
				);
}

 render(box(vcat(boxes)));
}

// show all occurences of the block duplicateText TODO um welchen Text handelt es sich
//TODO: check that not in the same file
public void showDuplicatesInOtherFiles(str duplicateText, str filepath){
	list[Figure] boxes = [box(text("Duplicate in other files"))];
	
	for (list[LineType] listOfOcc <- duplWholeFile[duplicateText]){
		loc locat = listOfOcc[0].file;
		if(locat.path != filepath){
		boxes += box(text("In file: " + locat.path + "\n \n lines: <listOfOcc[0].index> - <listOfOcc[5].index>" ), //TODO: add line numbers
		
				onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
				showClassFigure(); //go back to overview
				return true;
				}));
				}
	}
	render(box(vcat(boxes)));


}

// TODO: adapt boundaries and take the number of duplicates contained in the file
public Color getColorForDuplRating(map[str, list[list[LineType]]] duplPerFile){
	int number = 0;
	for(str text <- duplPerFile){
		number += size(duplPerFile[text]);
	}
	
	if(number == 0){
		return rgb(161, 224, 53); //green
	}
	else if (number < 3){
		return rgb(236, 239, 26); //yellow
	}
	else {
		return rgb(226, 32, 22); //red
	}
}