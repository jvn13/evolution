module Visualization

import Helper;
import IO;
import List;
import Set;
import util::Math;

public void printInfo(ScoresType scores, map[str,int] ratings) {
	map[str,str] ratingsSymbols = (metric : ratingToSymbol(ratings[metric]) | metric <- ratings);
	// Header
	println("Metric\t\t\tValue\t\t\tRating");
	println("------------------------------------------------------------");
	// Volume
	println("Volume:\t\t\t<scores.volume>\t\t\t<ratingsSymbols["volume"]>");
	// Unit Size
	println("Unit Size:\t\t<calculateAverage(scores.unitSize)> (avg)\t\t<ratingsSymbols["unitSize"]>");
	// Unit CC
	println("Unit Complexity:\t<calculateAverage(scores.unitCC)> (avg)\t\t<ratingsSymbols["unitCC"]>");
	// Duplicates
	println("Duplicates:\t\t<scores.duplicates> (<scores.duplicatePercentage>%)\t\t<ratingsSymbols["duplicates"]>");
	println("Redundants:\t\t<scores.redundants> (<scores.redundantPercentage>%)\t\tn/a");
	println("Unit Interfaces:\t<calculateAverage(scores.unitInterfaces)> (avg)\t\t<ratingsSymbols["unitInterfaces"]>");
	println();
	
	analysability = round(0.4*ratings["volume"] + 0.2*ratings["duplicates"] + 0.4*ratings["unitSize"]);
	changeability = round(0.5*ratings["unitCC"] + 0.5*ratings["duplicates"]);
	testability = round(0.7*ratings["unitCC"] + 0.3*ratings["unitSize"]);
	reusability = round((ratings["unitSize"] + ratings["unitInterfaces"])/2); 
	maintainability = round((analysability + changeability + testability + reusability)/4);
	
	println("Characteristic\t\tRating");
	println("----------------------------------------");
	println("Analysability:\t\t<ratingToSymbol(analysability)>");
	println("Changeability:\t\t<ratingToSymbol(changeability)>");
	println("Testability:\t\t<ratingToSymbol(testability)>");
	println("Reusability:\t\t<ratingToSymbol(reusability)>");
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

public str ratingToSymbol(int rank) {
	switch(rank) {
		case 5: return "++";
		case 4: return "+";
		case 3: return "o";
		case 2: return "-";
		case 1: return "--";
	}	
}