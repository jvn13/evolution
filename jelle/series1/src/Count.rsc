module Count

import IO;
import List;
import lang::java::jdt::m3::Core;

public int countAllLines(list[str] classSrc) {
	return size(classSrc);
}

public int countBlankLines(list[str] classSrc) {
	n = 0;
	for(line <- classSrc) {
		if(/^[ \t\r\n]*$/ := line)
			n += 1;
	}
	return n;
}

public int countCommentLines(list[str] classSrc) {
	n = 0;
	for(line <- classSrc)
		// TODO: change regex to just start of the line
		if(/(\/\/)|(\/\*)|(\*\/)/ := line)
			n += 1;
	return n;
}

public int countProjectLines(M3 mmm) {
	n = 0;
	my_classes = classes(mmm);
	for(c <- my_classes) {
		classSrc = readFileLines(c);
		total = countAllLines(classSrc);
		blank = countBlankLines(classSrc);
		comments = countCommentLines(classSrc);
		n += (total-blank-comments);
	}
	return n;
}