module Analyzation

import Count;
import IO;
import List;
import TypeOneDuplication;
import util::Benchmark;

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
	println(lines[39]);
	//getInterfaceAndLocPerMethod(project);
	duplicates = getDuplicateLinesPerProject(lines);
	//iprintln(duplicates);
	println(size(lines));
	println(typeOne.lines);
}
