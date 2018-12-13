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
public list[LineType] lines = [];
public list[str] overlappingBlocks = [];


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

	lines = getProjectLoc(project);
	duplicates = getDuplicateLinesPerProject(lines);
	
	println("Original number of clone classes: <size(duplicates)>");
	duplicates = createLargerCloneClasses(duplicates);
	println("Number of clone classes: <size(duplicates)>");

	biggestCloneClass = sort(getBiggestCloneClass(duplicates));
	println(last(biggestCloneClass));

	// writeExportFile(project, duplicates);
	
	printReport(duplicates);
}


private void printReport(map[str, list[list[LineType]]] duplicates) {
	println("REPORT\n-------------------------");
	println("Volume\t\t\t\t<size(lines)>");
	println("Number of clones\t\t\t<typeOne.lines>");
	println("% of duplicated lines\t\t<typeOne.lines / toReal(size(lines)) * 100>%");
	println("Number of clone classes\t\t<size(duplicates)>");
	println("-------------------------");
}

/*
TODO: TEEESSSTTT
*/
public void writeExportFile(loc project, map[str, list[list[LineType]]] cloneClasses){
	loc exportLocation = toLocation("project://series2/src/"); 
	locatFile = project.authority + "_result" + ".txt";
	exportString = "";
	
	for(str textual <- cloneClasses){
	exportString += textual + "<cloneClasses[textual][0][0].index> - <cloneClasses[textual][0][5].index> \n"; //TODO what to export
	}
	
	writeFile(exportLocation + locatFile, exportString);
}