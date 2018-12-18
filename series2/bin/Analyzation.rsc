module Analyzation

import CloneClasses;
import Count;
import Helper;
import IO;
import List;
import Map;
import Report;
import String;
import TypeOneDuplication;
import Visualization;
import util::Benchmark;
import util::Math;

public int BLOCK_SIZE = 6;
public list[LineType] LINES = [];
public int typeOne = 0;
public list[str] overlappingBlocks = [];
public map[str, list[list[LineType]]] CLONE_CLASSES = ();
private loc EXPORTCLONECLASSES = toLocation("project://series2/src/");

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
		list[loc] projectFiles = getFiles(project);
		Analyze(project, projectFiles);
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
private void Analyze(loc project, list[loc] projectFiles) {

	LINES = getProjectLoc(projectFiles);
	CLONE_CLASSES = getDuplicateLinesPerProject(LINES);
	
	CLONE_CLASSES = createLargerCloneClasses(CLONE_CLASSES);

	tuple[int, str] biggestCloneClass = getBiggestCloneClass(CLONE_CLASSES);
	tuple[int,str] biggestClone = getBiggestClone(CLONE_CLASSES);

	printReport(biggestCloneClass, biggestClone);

	writeExportFile(project);
	// showClasses(project);
}

public void writeExportFile(loc project){
	locatFile = project.authority + "_result" + ".txt";
	exportString = "";
	
	for(str textual <- CLONE_CLASSES){
		exportString += " LINES: \t\t";
		for(list[LineType] lines <- CLONE_CLASSES[textual]){
			exportString += "| <lines[0].file.file >: <lines[0].index> - <lines[size(lines)-1].index> |";
		}
		exportString += left("\n CLONE CLASS: \t" + textual + "\n \n",60);
	}
	
	writeFile(EXPORTCLONECLASSES + locatFile, exportString);
}