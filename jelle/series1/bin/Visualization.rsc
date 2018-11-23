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
	println("Characteristic\t\tValue\t\t\tRating");
	println("------------------------------------------------------------");
	// Volume
	println("Volume:\t\t\t<scores.volume>\t\t\t<ratingsSymbols["volume"]>");
	// Unit Size
	avgSize = round(sum(scores.unitSize)/toReal(size(scores.unitSize)),0.001);
	println("Unit Size:\t\t<avgSize> (avg)\t\t<ratingsSymbols["unitSize"]>");
	// Unit CC
	avgCC = round(sum(scores.unitCC)/toReal(size(scores.unitCC)),0.001);
	println("Unit Complexity:\t<avgCC> (avg)\t\t<ratingsSymbols["unitCC"]>");
	// Duplicates
	println("Duplicates:\t\t<scores.duplicates> (<scores.duplicatePercentage>%)\t\t<ratingsSymbols["duplicates"]>");
	println("Previously seen:\t<scores.seen> (<scores.seenPercentage>%)\t\t<ratingsSymbols["seen"]>");
	println();
	
	analysability = floor(0.4*ratings["volume"] + 0.2*ratings["duplicates"] + 0.4*ratings["unitSize"]);
	changeability = floor(0.5*ratings["unitCC"] + 0.5*ratings["duplicates"]);
	testability = floor(0.7*ratings["unitCC"] + 0.3*ratings["unitSize"]);
	maintainability = (analysability + changeability + testability)/3;
	
	println("Characteristic\t\tRating");
	println("----------------------------------------");
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