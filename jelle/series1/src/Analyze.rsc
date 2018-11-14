module Analyze

import CC;
import Count;
import Duplication;
import IO;
import List;
import Map;
import Rank;
import Read;
import Set;
import lang::java::jdt::m3::Core;
import util::Math;

public void main() {
	 loc project = |project://smallsql0.21_src|;
	//loc project = |project://BinaryConverter|;
	//loc project = |project://hsqldb-2.3.1|;
	
	mmm = read(project);
	list[loc] projectFiles = getFiles(project);
	lines = getProjectLoc(projectFiles);
	
	visiualize();
	
	// Volume
	volume = size(lines);
	volumeRank = getVolumeRank(volume);
	println("Volume: \t\t<volume> \t\t<rankToSymbol(volumeRank)>");
	
	// Unit Size
	unitSizes = getLocPerMethod(mmm);
	unitSizeRisks = unitRisk(unitSizes, <10, 100, 200>);
  unitSizeRank = getUnitRank(unitSizeRisks);
  println("Unit Size: \t\t<sum(unitSizes)/toReal(size(unitSizes))> \t<rankToSymbol(unitSizeRank)>");
	
	// Unit Complexity
	unitComplexities = [2,4,5,6]; // TODO
	unitComplexityRisks = unitRisk(unitComplexities, <10, 20, 50>);
	unitComplexityRank = getUnitRank(unitComplexityRisks);
	println("Unit Complexity: \t<sum(unitComplexities)/toReal(size(unitComplexities))> \t\t<rankToSymbol(unitComplexityRank)>");
	
	// Duplication
	map[str,list[list[int]]] duplicateBlocks = createBlocks(lines);
	set[int] duplicateLines = blockToLines(duplicateBlocks);
	println("Duplicates: \t\t<size(duplicateLines)> \t\t<rankToSymbol(getDuplicationRank(calculatePercentage(size(duplicateLines), size(lines))))>");
}

public void visiualize() {
	println("Metric \t\t\tValue \t\tRank");
  println("-----------------------------------------------");
}