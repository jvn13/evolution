module Count

import Helper;
import IO;
import List;
import String;
import lang::java::jdt::m3::Core;

private bool inComment = false;

/*
 * Reads in all the files in the project and combines all 
 * the source code lines in one big list.
 *
 * @param project - location of the project.
 * @return list[str] - list of all the source code lines.
 *
 */
public list[LineType] getProjectLoc(loc project) {
	lines = [];
	
	list[loc] projectFiles = getFiles(project);
	for(file <- projectFiles) lines += getLoc(file);
	return lines;
}

/*
 * Read in a file as lines and removes the empty and comment lines.
 *
 * @param file - location of the file
 * @return list[str] - list of the source code lines
 *
 */
public list[LineType] getLoc(loc file) {
	list[str] lines = readFileLines(file);
	
	list[LineType] code = [];
	
	for(int lineIndex <- [0..size(lines)]) {
		str lineValue = trim(lines[lineIndex]);
		
		lineValue = removeComments(lineValue);
		
		if(!isEmpty(lineValue) && !inComment) code += [Line(file, lineIndex + 1, lineValue)];
	}
	return code;
}

public str removeComments(str lineValue) {
	lineValue = removeSingleLineComment(lineValue);
	lineValue = removeMultiLineComment(lineValue);
	return lineValue;
}

public str removeSingleLineComment(str lineValue) {
	commentIndex = findFirst(lineValue, "//");
	if(commentIndex != -1) {
		lineValue = trim(lineValue[..commentIndex]);
	}
	return lineValue;
}

public str removeMultiLineComment(str lineValue) {
	startCommentIndex = findFirst(lineValue, "/*");
	endCommentIndex = findFirst(lineValue, "*/");
	if(startCommentIndex != -1 && endCommentIndex != -1) {
		lineValue = trim(lineValue[..startCommentIndex]) + trim(lineValue[(endCommentIndex+2)..]);
	} else if(startCommentIndex != -1) {
		lineValue = trim(lineValue[..startCommentIndex]);
		inComment = true;
	} else if(endCommentIndex != -1) {
		lineValue = trim(lineValue[(endCommentIndex+2)..]);
		inComment = false;
	}
	return lineValue;
}

/*
 * Creates an M3 model of the project and extracts the methods from that.
 * Creates a list of the lines of each method and calculates the number
 * of parameters and size of each method.
 *
 * @param project - location of the project.
 * @return list[tuple[int, int]] - list of tuples containing the method interface and size.
 *
 */
public void getInterfaceAndLocPerMethod(loc project) {
	mmm = read(project);
	mm = {<e,f> | <e,f> <- mmm.declarations, isMethod(e)};
	iprintln(mm);
}