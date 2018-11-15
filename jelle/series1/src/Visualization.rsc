module Visualization

import Helper;
import IO;
import List;
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

public void printInfo(ScoresType scores, map[str,int] ratings) {
	map[str,str] ratingsSymbols = (metric : ratingToSymbol(ratings[metric]) | metric <- ratings);
	// Header
	println("Metric\t\t\tValue\t\tRating");
	println("--------------------------------------------------");
	// Volume
	println("Volume:\t\t\t<scores.volume>\t\t<ratingsSymbols["volume"]>");
	// Unit Size
	avgSize = round(sum(scores.unitSize)/toReal(size(scores.unitSize)),0.001);
	println("Unit Size:\t\t<avgSize>\t\t<ratingsSymbols["unitSize"]>");
	// Unit CC
	avgCC = round(sum(scores.unitCC)/toReal(size(scores.unitCC)),0.001);
	println("Unit Complexity:\t<avgCC>\t\t<ratingsSymbols["unitCC"]>");
	// Duplicates
	println("Duplicates:\t\t<scores.duplicates>\t\t<ratingsSymbols["duplicates"]>\n");
	
	analysability = (ratings["volume"] + ratings["duplicates"] + ratings["unitSize"])/3.0;
	changeability = (ratings["unitCC"] + ratings["duplicates"])/2.0;
	testability = (ratings["unitCC"] + ratings["unitSize"])/2.0;
	
	println("<analysability> : <changeability> : <testability>");
}