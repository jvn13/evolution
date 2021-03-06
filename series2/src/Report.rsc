module Report

import Analyzation;
import Helper;
import IO;
import List;
import Map;
import util::Math;

/*
 * Prints the metrics of the report
 */
public void printReport(tuple[int, str] biggestCloneClass, tuple[int, str] biggestClone) {
	println("REPORT\n-------------------------");
	println("Volume\t\t\t\t<size(LINES)> lines");
	println("% of duplicated lines\t\t<typeOne / toReal(size(LINES)) * 100>%");
	println("Number of clones\t\t<typeOne> lines");
	println("Number of clone classes\t\t<size(CLONE_CLASSES)>");
	println("Biggest clone\t\t\t<biggestClone[0]> occurrences");
	println("Biggest clone class\t\t<biggestCloneClass[0]> lines");
	println("Example clones:");
	for (int i <- [1 .. 3]) {
		print("\n\tExample <i> [");
		int index = arbInt(size(CLONE_CLASSES));
		printExample(index);
	}	
	println("-------------------------");
}

/*
 * Prints a clone line for line, including the locations where it can be found.
 */
private void printExample(int index) {
	list[str] keys = [k | k <- CLONE_CLASSES];
	
	for(block <- CLONE_CLASSES[keys[index]]) {
		print(" <block[0].file.file >: <block[0].index> - <block[size(block)-1].index>,");
	}
	print("]\n");
	
	for (line <- CLONE_CLASSES[keys[index]][0]) {
		println("\t\t<line.val>");
	}
}