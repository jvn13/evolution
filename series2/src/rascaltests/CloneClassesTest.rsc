module rascaltests::CloneClassesTest

import Analyzation;
import CloneClasses;
import Count;
import Helper;
import IO;
import List;
import Map;
import TypeOneDuplication;

public bool cloneClassesTest(str name, list[loc] files, int exact) {
	list[LineType] lines = getProjectLoc(files);
	map[str, list[list[LineType]]] cloneClasses = getDuplicateLinesPerProject(lines);
	cloneClasses = createLargerCloneClasses(cloneClasses);
	if(size(cloneClasses) != exact) return false;
	return true;
}

test bool wrongOverlap() = cloneClassesTest(
	"Overlap not behind eachother", 
	[|project://series2/src/testfiles/F1.java|],
	1
);

test bool Subsumed() = cloneClassesTest(
	"Subsumed", 
	[|project://series2/src/testfiles/F2.java|, |project://series2/src/testfiles/F4.java|],
	1
);

test bool PartlyPartlyNot() = cloneClassesTest(
	"Partly subsumed, partly not", 
	[|project://series2/src/testfiles/F2.java|, |project://series2/src/testfiles/F3.java|, 
	 |project://series2/src/testfiles/F4.java|],
	2
);