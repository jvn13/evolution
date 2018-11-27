module Count

import IO;
import List;
import Read;
import String;
import lang::java::jdt::m3::Core;
import Type;

public list[str] getLoc(loc file) {
	list[str] lines = readFileLines(file);
	
	list[str] code = [];
	bool inComment = false;
	
	for(l <- lines) {
		l = trim(l);
		
		// Find the index of single line comment and remove everything behind it
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

public list[int] getParameterCountPerMethod(loc project) {
	parametersPerMethod = [];
	mmm = read(project);
	projectParameters = parameters(mmm);
	projectMethods = methods(mmm);
	for(projectMethod <- projectMethods) {
		counter = 0;
		methodPath = projectMethod.path;
		methodParameters = [p | p <- projectParameters, contains(p.path, methodPath)];
		parametersPerMethod += [size(methodParameters)];
	}
	return parametersPerMethod;
}

public int parameterTest(list[str] lines) {
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

public tuple[list[int], list[int]] getLocPerMethod(loc project) {
	mmm = read(project);
	linesPerMethod = [getLoc(m) | m <- methods(mmm)];
	return <[size(m) | m <- linesPerMethod], [parameterTest(m) | m <- linesPerMethod]>;
}

public list[str] getProjectLoc(loc project) {
	list[loc] projectFiles = getFiles(project);
	lines = [];
	for(file <- projectFiles) lines += getLoc(file);
	return lines;
}