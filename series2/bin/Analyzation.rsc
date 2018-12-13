module Analyzation

import CloneClasses;
import Count;
import Helper;
import IO;
import List;
import Map;
import String;
import TypeOneDuplication;
import util::Benchmark;
import util::Math;

public int BLOCK_SIZE = 6;
public list[LineType] LINES = [];
public list[str] overlappingBlocks = [];
private map[str, list[list[LineType]]] CLONE_CLASSES = ();


/*
 * Runs the analyzation for the smallsql project
 *
 */
public void runSmallSQL() {
	loc project = |project://smallsql0.21_src|;
	runAnalyzation(project);
}

/*
 * Runs the analyzation for the hsql project
 *
 */
public void runHsql() {
	loc project = |project://hsqldb-2.3.1|;
	runAnalyzation(project);
}

/*
 * Runs the analyzation for the provided project
 * and keeps track of the duration of the execution.
 * 
 * @ param project - location of the project to analyze.
 *
 */
public void runAnalyzation(loc project) {
	time = realTime(void () {
		Analyze(project);
	});
	println("Execution time: <time> ms");
}

/*
 * Calculates all the desired metrics and ratings for the project.
 * Calls a function to pretty print the results.
 *
 * @param project - location of the project.
 *
 */
private void Analyze(loc project) {

	LINES = getProjectLoc(project);
	CLONE_CLASSES = getDuplicateLinesPerProject(LINES);
	
	CLONE_CLASSES = createLargerCloneClasses(CLONE_CLASSES);

	tuple[int, str] biggestCloneClass = getBiggestCloneClass(CLONE_CLASSES);
	tuple[int,str] biggestClone = getBiggestClone(CLONE_CLASSES);

	printReport(biggestCloneClass, biggestClone);

	writeExportFile(project);
}


private void printReport(tuple[int, str] biggestCloneClass, tuple[int, str] biggestClone) {
	println("REPORT\n-------------------------");
	println("Volume\t\t\t\t<size(LINES)> lines");
	println("Number of clones\t\t<typeOne.lines> lines");
	println("% of duplicated lines\t\t<typeOne.lines / toReal(size(LINES)) * 100>%");
	println("Number of clone classes\t\t<size(CLONE_CLASSES)>");
	println("Biggest clone\t\t\t<biggestClone[0]> lines");
	println("Biggest clone class\t\t<biggestCloneClass[0]> lines");
	// TODO
	println("Example clones");
	println("-------------------------");
}

/*
TODO: TEEESSSTTT
*/
public void writeExportFile(loc project){
	loc exportLocation = toLocation("project://series2/src/"); 
	locatFile = project.authority + "_result" + ".txt";
	exportString = "";
	
	for(str textual <- CLONE_CLASSES){
		exportString += textual + "<CLONE_CLASSES[textual][0][0].index> - <CLONE_CLASSES[textual][0][5].index> \n"; //TODO what to export
	}
	
	writeFile(exportLocation + locatFile, exportString);
}