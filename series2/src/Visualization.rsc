module Visualization

import vis::KeySym;
import vis::Figure;
import vis::Render;

import TypeOneDuplication;
import CloneClasses;
import Count;
import Read;
import List;
import IO;
import Helper;
import Map;
import util::Math;

map[str, list[list[LineType]]] duplWholeFile;

public void showClassFigure(){
	loc smallsql = |project://smallsql0.21_src|;
	
	showClasses(smallsql);
}

//overview classes
public void showClasses(loc projectLocation){
	projLoc = getProjectLoc(getFiles(projectLocation));
	duplWholeFile = getDuplicateLinesPerProject(projLoc);
	duplWholeFile = createLargerCloneClasses(duplWholeFile);
	
	list[loc] files = getFiles(projectLocation);
	list[Figure] boxes = [];
		
	for(loc file <- files){ 
	
		lengthOfFile = size(readFileLines(file));
		duplForFile = filterForFile(file);
		filepath = file.path; //has to be done like this, otherwise last element of files is taken
		
		boxes += box(text(file.path),
				fillColor(getColorForDuplRating(duplForFile, lengthOfFile)),
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

//show duplicates on class level
public void showDuplicates(map[str block, list[list[LineType]] mapOfDuplLines] duplPerFile, str filepath){

goBackToOverview = box(text("To overview"),
				onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
				showClassFigure(); //go back to overview
				return true;
				}));
				
	list[Figure] boxes = [hcat([box(text(filepath)),goBackToOverview])];


for (str duplText <- duplPerFile){
	
	textDupFormated="";
	textDupUnformated=duplText;
	
	// find all lines where the block "duplText" appears
	for(line <- duplPerFile[duplText][0]){
		textDupFormated+="<line.val> \n";
	}
	
	occurences = "";
	entriesOcc=0;
	
	for(list[LineType] occLine <- duplPerFile[textDupUnformated]){
			occurences += "line: <occLine[0].index>  -  <occLine[size(occLine)-1].index>, ";
			entriesOcc+=1;
			if(entriesOcc==3){
				occurences+="\n";
				entriesOcc=0;
			}
	}
	

	boxes += box(
				
				hcat([	text("lines: \n \n \n" +  "duplicated Block: ", fontColor("blue"), align(0,0) ), 
						text(occurences + "\n \n" + textDupFormated, align(0, 0))]),
 								
				onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
				showDuplicatesInOtherFiles(textDupUnformated,textDupFormated, filepath); //TODO
				return true;
				})
				
				);
}

 render(box(vcat(boxes)));
}

// show all occurences (not in the same file) of the block duplicateText
public void showDuplicatesInOtherFiles(str duplicateText, str duplicateTextFormated, str filepath){
	
	goBackToOverview = box(text("To overview"),
				
				onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
				showClassFigure(); //go back to overview
				return true;
				}));
				
	list[Figure] boxes = [hcat([box(text("Duplicate in other files \n " + duplicateTextFormated)),goBackToOverview])];
	
	for (list[LineType] listOfOcc <- duplWholeFile[duplicateText]){
		loc locat = listOfOcc[0].file;
		if(locat.path != filepath){
		boxes += box(text("In file: " + locat.path + "\n \n lines: <listOfOcc[0].index> - <listOfOcc[size(listOfOcc)-1].index>" )); //TODO: add line numbers
				}
	}
	render(box(vcat(boxes)));


}


public Color getColorForDuplRating(map[str, list[list[LineType]]] duplPerFile, int lengthOfFile){
	int numberOfDupl = 0;
	
	for(str text <- duplPerFile){
		for(list[LineType] lines <- duplPerFile[text]){
			numberOfDupl += size(lines);
		}
	}
	
	percentageOfDupl = toReal(numberOfDupl) / toReal(lengthOfFile);
	
	if(numberOfDupl < 0.03){
		return rgb(161, 224, 53); //green
	}
	else if (percentageOfDupl < 0.2){
		return rgb(236, 239, 26); //yellow
	}
	else {
		return rgb(226, 32, 22); //red
	}
}