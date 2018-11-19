module DuplicationTest

import Duplication;
import Count;
import IO;

/* test duplication in one file */

// test for duplicate block of 2 lines
loc fileWithTwoDuplicateLines = |project://series1/src/testfiles/duplicates/ClassWithTwoDuplicateLines.java|;
list[str] linesOfOfFileWithTwoDuplLines = getProjectLoc(fileWithTwoDuplicateLines);

test bool compareFileWithTwoDuplLines_returnsZeroLines() = getDuplicateLinesPerProject(linesOfOfFileWithTwoDuplLines) == 0;

// test for duplicate block of 7 lines
loc fileWithDuplicateOfSevenLines = |project://series1/src/testfiles/duplicates/ClassWithOneDuplicateBlockOfSevenLines.java|;
list[str] linesOfFileWithDuplOfSeven = getProjectLoc(fileWithDuplicateOfSevenLines);

test bool compareTwoFilesWithDupl_returnsSevenLines() = getDuplicateLinesPerProject(linesOfFileWithDuplOfSeven) == 7;



/* test duplication in two files */
loc pathToTwoDuplicateFiles = |project://series1/src/testfiles/duplicates|;
list[str] linesOfDuplicateFiles = getProjectLoc(pathToTwoDuplicateFiles);

test bool compareTwoFilesWithDupl_returnsLines() {
println("Test1: <getDuplicateLinesPerProject(linesOfDuplicateFiles)>");
return getDuplicateLinesPerProject(linesOfDuplicateFiles) == 20; //is that what we want?
}


/* test duplication in three files */
loc pathToThreeDuplicateFiles = |project://series1/src/testfiles|;
list[str] linesOfDuplicateThreeFiles = getProjectLoc(pathToThreeDuplicateFiles);

test bool compareThreeFilesWithDupl_returnsLines(){
println("Test2: <getDuplicateLinesPerProject(linesOfDuplicateThreeFiles)>");
 return getDuplicateLinesPerProject(linesOfDuplicateThreeFiles) == 14; //result is 15????
 
 // What happens if there are 2 files which have the same 5 lines in the end and they are in the same package. This is the 6. duplicated line???
}