module Duplication

import IO;
import String;
import List;
import Set;
import Map;
import Visualization;

public int getDuplicateLinesPerProject(list[str] lines) {
	// map[str,list[list[int]]] duplicateBlocks = getDuplicateBlocks(lines);
	// set[int] duplicateLines = blockToLines(duplicateBlocks);
	// printDuplicates(lines, duplicateLines); 
	int duplicates = getDuplicateBlocks(lines);
	return duplicates;
}

private set[int] blockToLines(map[str,list[list[int]]] duplicates) {
	set[int] dupLines = {};
	for(block <- duplicates) {
		lines = tail(duplicates[block]);
		for(l <- lines) {
			dupLines += toSet(l);
		}
	}
	return dupLines;
}

private int getDuplicateBlocks(list[str] lines) {
	map[str,list[list[int]]] blocks = ();
	
	int dupCounter = 0;
	bool inBlock = false;
	
	int counter = 0;
	
	for(int i <- [0 .. size(lines) - 5]) {
		str block = "";
		
		for(int j <- [0 .. 6]) block += lines[i + j];
		
		if(block in blocks) {
			blocks[block] += [[i .. (i + 6)]];
			
			if(inBlock) {
				dupCounter += 1;
			} else {
				dupCounter += 6;
				inBlock = true;
			}
			counter += 1;
		} else {
			blocks += ( block : [[i .. (i + 6)]]);
			inBlock = false;
		}
	}
	// println("Duplicate blocks: <counter>");
	// return (block : blocks[block] | block <- blocks, size(blocks[block]) > 1);
	return dupCounter;
}