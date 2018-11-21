module DuplicationTest

import Duplication;
import Count;
import IO;
import List;
import util::Math;

public bool duplicationTest(str name, loc project, int exact) {
	list[str] lines = getProjectLoc(project);
	duplicates = getDuplicateLinesPerProject(lines);
	println("\n<name>: <duplicates>, <duplicates/toReal(size(lines))*100>%");
	return duplicates == exact;
}

test bool fileOrder() = duplicationTest(
	"File Order Test", 
	|project://series1/src/testfiles/fileOrder|, 
	12
);

test bool sameFiles() = duplicationTest(
	"Same Files", 
	|project://series1/src/testfiles/sameFiles|,
	36
);

test bool oneFile() = duplicationTest(
	"One File", 
	|project://series1/src/testfiles/sameFiles/File1.java|,
	12
);


