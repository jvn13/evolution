module Report

import Analyzation;
import Helper;
import IO;
import List;
import Map;
import util::Math;

public void printReport(tuple[int, str] biggestCloneClass, tuple[int, str] biggestClone) {
	println("REPORT\n-------------------------");
	println("Volume\t\t\t\t<size(LINES)> lines");
	println("% of duplicated lines\t\t<typeOne.lines / toReal(size(LINES)) * 100>%");
	println("Number of clones\t\t<typeOne.lines> lines");
	println("Number of clone classes\t\t<size(CLONE_CLASSES)>");
	println("Biggest clone\t\t\t<biggestClone[0]> lines");
	println("Biggest clone class\t\t<biggestCloneClass[0]> lines");
	// TODO
	println("Example clones:");
	for (int i <- [1 .. 3]) {
		println("\n\tExmaple <i>");
		int index = arbInt(size(CLONE_CLASSES));
		printExample(index);
	}	
	println("-------------------------");
}

private void printExample(int index) {
	list[str] keys = [k | k <- CLONE_CLASSES];
	for (line <- CLONE_CLASSES[keys[index]][0]) {
		println("\t\t<line.val>");
	}
}