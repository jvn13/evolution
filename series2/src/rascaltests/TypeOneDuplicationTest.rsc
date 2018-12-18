module rascaltests::TypeOneDuplicationTest

import TypeOneDuplication;
import Count;
import Helper;
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
	list[LineType] lines = getProjectLoc(getFiles(project));
	map[str, list[list[LineType]]] duplicates = getDuplicateLinesPerProject(lines);
	int numberOfDupl = getNumberOfDuplicates(duplicates);
	return numberOfDupl == exact;
}

test bool fileOrder() = duplicationTest(
	"File order", 
	|project://series2/src/testfiles/fileOrder|, 
	21
);

test bool someOverlap() = duplicationTest(
	"Some overlap", 
	|project://series2/src/testfiles/basicDuplication|,
	41
);

test bool sameFiles() = duplicationTest(
	"Two identical files", 
	|project://series2/src/testfiles/sameFiles|,
	48
);

test bool oneFile() = duplicationTest(
	"One file",
	|project://series2/src/testfiles/sameFiles/File1.java|,
	18
);

test bool zeroCase() = duplicationTest(
	"Block of 7", 
	|project://series2/src/testfiles/basicDuplication/File2.java|,
	14
);

test bool zeroCase() = duplicationTest(
	"Zero case", 
	|project://series2/src/testfiles/basicDuplication/File1.java|,
	0
);