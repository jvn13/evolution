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

public list[int] getLocPerMethod(loc project) {
	mmm = read(project);
	return [size(getLoc(m)) | m <- methods(mmm)];
}

public list[str] getProjectLoc(loc project) {
	list[loc] projectFiles = getFiles(project);
	lines = [];
	for(file <- projectFiles) lines += getLoc(file);
	return lines;
}