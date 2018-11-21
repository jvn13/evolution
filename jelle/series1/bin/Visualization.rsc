module Visualization

import Helper;
import IO;
import List;
import Set;
import util::Math;

public str ratingToSymbol(int rank) {
	switch(rank) {
		case 5: return "++";
		case 4: return "+";
		case 3: return "o";
		case 2: return "-";
		case 1: return "--";
	}	
}

public void printDuplicates(list[str] lines, set[int] duplicateLines) {
	orderedDuplicateLines = sort(toList(duplicateLines));
	for(d <- orderedDuplicateLines) {
		println("<d> : <lines[d]>");
	}
}

public void printInfo(ScoresType scores, map[str,int] ratings) {
	map[str,str] ratingsSymbols = (metric : ratingToSymbol(ratings[metric]) | metric <- ratings);
	// Header
	println("Metric\t\t\tValue\t\tRating");
	println("--------------------------------------------------");
	// Volume
	println("Volume:\t\t\t<scores.volume>\t\t<ratingsSymbols["volume"]>");
	// Unit Size
	avgSize = round(sum(scores.unitSize)/toReal(size(scores.unitSize)),0.001);
	println("Unit Size:\t\t<avgSize> (avg)\t<ratingsSymbols["unitSize"]>");
	// Unit CC
	avgCC = round(sum(scores.unitCC)/toReal(size(scores.unitCC)),0.001);
	println("Unit Complexity:\t<avgCC> (avg)\t<ratingsSymbols["unitCC"]>");
	// Duplicates
	println("Duplicates:\t\t<scores.duplicates> (<scores.duplicatePercentage>%)\t<ratingsSymbols["duplicates"]>");
	println();
	
	analysability = floor((ratings["volume"] + ratings["duplicates"] + ratings["unitSize"])/3.0);
	changeability = floor((ratings["unitCC"] + ratings["duplicates"])/2.0);
	testability = floor((ratings["unitCC"] + ratings["unitSize"])/2.0);
	maintainability = (analysability + changeability + testability)/3;
	
	println("Metric\t\t\tRating");
	println("--------------------------------------------------");
	println("Analysability:\t\t<ratingToSymbol(analysability)>");
	println("Changeability:\t\t<ratingToSymbol(changeability)>");
	println("Testability:\t\t<ratingToSymbol(testability)>");
	println("Maintainability:\t<ratingToSymbol(maintainability)>\n");
}

public void printRiskProfile(str name, RiskProfile risks) {
	println("<name> risks");
	println("----------------------");
	println("Low:\t\t<risks.low>%");
	println("Moderate:\t<risks.moderate>%");
	println("High:\t\t<risks.high>%");
	println("Very high:\t<risks.veryhigh>%\n");
}