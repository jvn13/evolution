module Analyzation

import Count;
import Helper;
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
	duplicates = getDuplicateLinesPerProject(lines);
	
	//iprintln(duplicates);
	//println(size(lines));
	//println(typeOne.lines);
	
	getCloneClasses(duplicates);
}

private str removeBlockLine(list[LineType] block, int lineIndex) {
	block = delete(block, lineIndex);
	str subBlock = "";
	for(line <- block) {
		subBlock += line.val;
	}
	return subBlock;
}

public void getCloneClasses(map[str, list[list[LineType]]] duplicates) {
	subBlocks = (removeBlockLine(duplicates[clone][0], size(duplicates[clone][0]) - 1) : clone | clone <- duplicates);
	
	for(clone <- duplicates) {
		println("-- <clone>");
		cloneClass = duplicates[clone];
		subBlock = removeBlockLine(cloneClass[0], 0);
		
		if(subBlock in subBlocks) {
			overlapingCloneClass = duplicates[subBlocks[subBlock]];
			// check for same size
			if(size(cloneClass) == size(overlapingCloneClass)) {
				// println("Possible superclass");
				// println("<clone> : <subBlocks[subBlock]>");
				
				// Check if the overlaping blocks are in the same file
				if(overlapFileCheck(cloneClass, overlapingCloneClass)) {
					println("possible superclass");
				}
			}
		}
	}
}

public bool overlapFileCheck(list[list[LineType]] cloneClass, list[list[LineType]] overlapingClass) {
	bool sameFile = true;
	for(int i <- [0 .. size(cloneClass)]) {
		for(int j <- [0 .. size(cloneClass[i])]) {
			if(cloneClass[i][j].file != overlapingClass[i][j].file) {
				sameFile = false;
				break;
			}
		}
	}
	return sameFile;
}