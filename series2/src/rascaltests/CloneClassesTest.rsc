module rascaltests::CloneClassesTest

import Analyzation;
import Count;
import IO;
import List;
import TypeOneDuplication;

public bool cloneClassesTest(str name, list[loc] files) {
	lines = [];
	for(file <- files) lines += getLoc(file);
	
	duplicates = getDuplicateLinesPerProject(lines);
	
	return true;
}

/*
test bool wrongOverlap() = cloneClassesTest(
	"Overlap not behind eachother", 
	[|project://series2/src/testfiles/F1.java|]
);
*/

test bool strange() = cloneClassesTest(
	"Strange", 
	[|project://series2/src/testfiles/F2.java|, |project://series2/src/testfiles/F4.java|]
);