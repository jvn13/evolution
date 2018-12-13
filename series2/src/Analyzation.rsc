module Analyzation

import Count;
import Helper;
import IO;
import List;
import Map;
import String;
import TypeOneDuplication;
import util::Benchmark;

import Type;

public int BLOCK_SIZE = 6;
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
	
 	println("Volume= <size(lines)>");
 	println("Duplicates = <typeOne.lines>");
	
	println("Original number of clone classes: <size(duplicates)>");
	duplicates = createLargerCloneClasses(duplicates);
	println("Number of clone classes: <size(duplicates)>");

	writeExportFile(project, duplicates);
}

private str removeLastLine(str block, map[str, list[list[LineType]]] duplicates) {
	str subBlock = "";
	for(line <- take(BLOCK_SIZE - 1, duplicates[block][0])) {
		subBlock += line.val;
	}
	return subBlock;
}

private str removeFirstLine(list[list[LineType]] block) {
	str subBlock = "";
	for(int i <- [size(block[0]) - (BLOCK_SIZE - 1) .. BLOCK_SIZE]) {
		// println(size(duplicates[block][0]) - (BLOCK_SIZE - 1));
		subBlock += block[0][i].val;
	}
	return subBlock;
}

private map[str, list[list[LineType]]] createLargerCloneClasses(map[str, list[list[LineType]]] duplicates) {
	partialBlocks = (removeFirstLine(duplicates[clone]) : clone | clone <- duplicates);
	map[str, str] subsumedClasses = ();
	
	overlappingBlocks = dup(overlappingBlocks);
	
	for(block <- overlappingBlocks) {
		if(block in subsumedClasses) {
			block = subsumedClasses[block];
		}
		if(block in duplicates) {
			subString = removeLastLine(block, duplicates);
		
			if(subString in partialBlocks) {
				// println("\nkey found= <partialBlocks[subString]> : <block>");
				
				str originalCloneClassString = partialBlocks[subString];
				list[list[LineType]] originalCloneClass = [[]];
				if(partialBlocks[subString] in duplicates) {
					originalCloneClass = duplicates[partialBlocks[subString]];
				} else if(partialBlocks[subString] in subsumedClasses) {
					//println(subsumedClasses[partialBlocks[subString]]);
					originalCloneClassString = subsumedClasses[partialBlocks[subString]];
					
					// TODO: fix this!!!!!! 
					if(originalCloneClassString in duplicates) {
						originalCloneClass = duplicates[originalCloneClassString];
					}
				}
				
				/*
				TODO: fix error about different size
					if(overlapFileCheck(originalCloneClass, duplicates[block])) {}
				*/
				if(size(duplicates[block]) == size(originalCloneClass)) {
					cloneClass = combineClasses(originalCloneClass, duplicates[block]);
					cloneClassStr = getBlockString(cloneClass);
					
					// add superclass
					subsumedClasses += (partialBlocks[subString] : cloneClassStr, block : cloneClassStr);
					duplicates += (cloneClassStr : cloneClass);
					
					// remove subclasses
					duplicates = delete(duplicates, originalCloneClassString);
					duplicates = delete(duplicates, block);
					overlappingBlocks = drop(1, overlappingBlocks);
				}
			}
		
		}
	}
	return duplicates;
}

private str getBlockString(list[list[LineType]] block) {
	str blockStr = "";
	for(line <- block[0]) {
		blockStr += line.val;
	}
	return blockStr;
}

private bool overlapFileCheck(list[list[LineType]] cloneClass, list[list[LineType]] overlapingClass) {
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

private list[list[LineType]] combineClasses(list[list[LineType]] cloneClass, list[list[LineType]] overlapingClass) {	
	return [dup(cloneClass[i] + overlapingClass[i]) | i <- [0 .. size(cloneClass)]];
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