module rascaltests::CountTest

import Count;
import Helper;
import IO;
import List;
import String;

private list[loc] testFiles = [
	|project://series2/src/testfiles/F1.java|,
	|project://series2/src/testfiles/F2.java|,
	|project://series2/src/testfiles/F4.java|
];

private list[tuple[int, int]] locPerFile = [];
private list[tuple[int, int]] slocPerFile = [];

test bool getLOCForEmptyFileLOCAndSLOC_Return0() {
	loc locEmptyFile = |project://series2/src/testfiles/EmptyFile.java|;
	
	list[LineType] linesProjLoc = getProjectLoc([locEmptyFile]);
	list[LineType] linesLoc = getLoc(locEmptyFile);
	
	return size(linesProjLoc) == 0 && size(linesLoc) == 0;
}

test bool getLocOfFile_returnListOfSize15(){
	loc locFile = |project://series2/src/testfiles/F1.java|;

	list[LineType] linesProjLoc = getProjectLoc([locFile]);
	list[LineType] linesLoc = getLoc(locFile);

	return size(linesProjLoc) == 15 && size(linesLoc) == 15;
}

test bool removeCommentsFromStringWithComments_ReturnStringWithoutComments(){
	str strWithComments = "1 \n 2 \n /* \n */ \n 3 //comment";
	str strWithoutComments = removeComments(strWithComments);
	return strWithoutComments == "1 \n 23";
}

test bool locTest() {
	if(isEmpty(locPerFile)) {
		loopFiles();
	}
	for(file <- locPerFile) {
		if(file[0] != file[1]) return false;
	}
	return true;
}

test bool slocTest() {
	if(isEmpty(slocPerFile)) {
		loopFiles();
	}
	for(file <- slocPerFile) {
		if(file[0] != file[1]) return false;
	}
	return true;
}

test bool projectSlocTest() {
	if(isEmpty(slocPerFile)) {
		loopFiles();
	}
	if(sum([v | <v, _> <- slocPerFile]) != size(getProjectLoc(testFiles))) return false;
	return true;
}

public void loopFiles() {
	for(file <- testFiles) {
		extractParameters(file);
	}
}

private void extractParameters(loc file) {
	list[str] lines = readFileLines(file);
	for(line <- lines) {
		
		commentIndex = findFirst(line, "//");
		if(commentIndex == -1) {
			break;
		}
		
		isIndex = findFirst(line, "=");
		if(isIndex != -1) {
			str name = trim(line[(commentIndex + 2) .. isIndex]);
			int val = toInt(trim(line[(isIndex + 1) ..]));
			setParameter(file, name, val);
		}
	}
}

private void setParameter(loc file, str name, int val) {
	switch(name) {
		case "LOC": locPerFile += <val, size(readFileLines(file))>;
		case "SLOC": slocPerFile += <val, size(getLoc(file))>;
		// case "DUPLICATES": DUPLICATES = val;
	}
}