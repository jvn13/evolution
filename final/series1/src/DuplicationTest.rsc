module DuplicationTest

import Duplication;
import Count;
import IO;
import List;
import util::Math;

/*
 * General method to handle the tests for Duplication.
 *
 * @param name - name of the specific test.
 * @param project - location of the project to test.
 * @param exact - hand calculates result.
 * @return bool - results matches exact param.
 *
 */
public bool duplicationTest(str name, loc project, int exact) {
	list[str] lines = getProjectLoc(project);
	<duplicates, _> = getDuplicateLinesPerProject(lines);
	println("\n<name>: <duplicates>, <duplicates / toReal(size(lines)) * 100>%");
	return duplicates == exact;
}

test bool fileOrder() = duplicationTest(
	"File order", 
	|project://series1/src/testfiles/fileOrder|, 
	12
);

test bool someOverlap() = duplicationTest(
	"Some overlap", 
	|project://series1/src/testfiles/basicDuplication|,
	25
);

test bool sameFiles() = duplicationTest(
	"Two identical files", 
	|project://series1/src/testfiles/sameFiles|,
	36
);

test bool oneFile() = duplicationTest(
	"One file",
	|project://series1/src/testfiles/sameFiles/File1.java|,
	12
);

test bool zeroCase() = duplicationTest(
	"Block of 7", 
	|project://series1/src/testfiles/basicDuplication/File2.java|,
	7
);

test bool zeroCase() = duplicationTest(
	"Zero case", 
	|project://series1/src/testfiles/basicDuplication/File1.java|,
	0
);