module rascaltests::CountTest

import Count;
import Helper;
import List;

test bool getLocOfEmptyFile_returnListOfSize0(){
	loc locEmptyFile = |project://series2/src/testfiles/EmptyFile.java|;
	
	list[LineType] linesProjLoc = getProjectLoc(locEmptyFile);
	list[LineType] linesLoc = getLoc(locEmptyFile);
	
	return size(linesProjLoc)==0 && size(linesLoc) == 0;
}

test bool getLocOfFile_returnListOfSize15(){
	loc locFile = |project://series2/src/testfiles/F1.java|;

	list[LineType] linesProjLoc = getProjectLoc(locFile);
	list[LineType] linesLoc = getLoc(locFile);

	return size(linesProjLoc) == 15 && size(linesLoc) == 15;
}

