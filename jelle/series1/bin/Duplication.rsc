module Duplication

import IO;
import String;
import List;
import Set;
import Map;

public int getDuplicateLinesPerProject(list[str] lines) {
	map[str,list[list[int]]] duplicateBlocks = getDuplicateBlocks(lines);
	set[int] duplicateLines = blockToLines(duplicateBlocks);
	return size(duplicateLines);
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

private map[str,list[list[int]]] getDuplicateBlocks(list[str] lines) {
	map[str,list[list[int]]] blocks = ();
	
	for(int i <- [0 .. size(lines) - 5]) {
		str block = "";
		
		for(int j <- [0 .. 6]) block += lines[i + j];
		
		if(block in blocks) {
			blocks[block] += [[i .. (i + 6)]];
		} else {
			blocks += ( block : [[i .. (i + 6)]]);
		}
	}
	return (block : blocks[block] | block <- blocks, size(blocks[block]) > 1);
}