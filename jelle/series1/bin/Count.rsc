module Count

import IO;
import List;
import String;
import lang::java::jdt::m3::Core;

public list[int] getLocPerMethod(M3 mmm) {
	return [size(getLoc(m)) | m <- methods(mmm)];
}

public list[str] getProjectLoc(list[loc] projectFiles) {
	lines = [];
	for(f <- projectFiles) {
		lines += getLoc(f);
	}
	return lines;
}

public list[str] getLoc(loc file) {
	list[str] lines = readFileLines(file);
	
	list[str] code = [];
	bool inComment = false;
	
	for(l <- lines) {
		l = trim(l);
		
		// Find the index of single line comment and remove everything behind it
		i = findFirst(l, "//");
		if(i != -1) {
			l = l[..i];
		}
		
		i = findFirst(l, "/*");
		j = findFirst(l, "*/");
		if(i != -1 && j != -1) {
			l = trim(l[..i]) + trim(l[(j+2)..]);
		} else if(i != -1) {
			l = l[..i];
			inComment = true;
		} else if(j != -1) {
			l = trim(l[(j+2)..]);
			inComment = false;
		}
		
		
		if(!isEmpty(l) && !inComment) {
			code += [l];
		}
	}
	return code;
}