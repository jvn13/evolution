module Count

import IO;
import List;
import Read;
import String;
import lang::java::jdt::m3::Core;
import Type;

/*
 * Read in a file as lines and removes the empty and comment lines.
 *
 * @param file - location of the file
 * @return list[str] - list of the source code lines
 *
 */
public list[str] getLoc(loc file) {
	list[str] lines = readFileLines(file);
	
	list[str] code = [];
	bool inComment = false;
	
	for(l <- lines) {
		l = trim(l);
		
		i = findFirst(l, "//");
		if(i != -1) {
			l = trim(l[..i]);
		}
		
		i = findFirst(l, "/*");
		j = findFirst(l, "*/");
		if(i != -1 && j != -1) {
			l = trim(l[..i]) + trim(l[(j+2)..]);
		} else if(i != -1) {
			l = trim(l[..i]);
			inComment = true;
		} else if(j != -1) {
			l = trim(l[(j+2)..]);
			inComment = false;
		}
		
		if(!isEmpty(l) && !inComment) code += [l];
	}
	return code;
}

/*
 * Reads in all the files in the project and combines all 
 * the source code lines in one big list.
 *
 * @param project - location of the project.
 * @return list[str] - list of all the source code lines.
 *
 */
public list[str] getProjectLoc(loc project) {
	list[loc] projectFiles = getFiles(project);
	lines = [];
	for(file <- projectFiles) lines += getLoc(file);
	return lines;
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
public list[tuple[int, int]] getInterfaceAndLocPerMethod(loc project) {
	mmm = read(project);
	linesPerMethod = [getLoc(m) | m <- methods(mmm)];
	return [<getParameterCount(m), size(m)> | m <- linesPerMethod];
}

/*
 * Takes the first line of the method lines 
 * and counts the number of parameters.
 *
 * @param lines - list of the lines of the method
 * @return int - number of parameters
 *
 */
public int getParameterCount(list[str] lines) {
	parameterCounter = 0;
	line = lines[0];
	
	startIndex = findFirst(line, "(") + 1;
	endIndex = findFirst(line, ")");
	line = line[startIndex .. endIndex];
	
	while(findFirst(line, ",") != -1) {
		i = findFirst(line, ",");
		line = line[(i + 1)..];
		if(line[..i] != "") {
			parameterCounter += 1;
		}
	}
	
	if(line != "") {
		parameterCounter += 1;
	}
	return parameterCounter;
}