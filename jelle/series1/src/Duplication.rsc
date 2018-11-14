module Duplication

import IO;
import String;
import List;
import Set;
import Map;

public set[int] blockToLines(map[str,list[list[int]]] duplicates) {
	set[int] dupLines = {};
	
	for(d <- duplicates) {
		lines = tail(duplicates[d]);
		
		for(l <- lines) {
			dupLines += toSet(l);
		}
	}
	return dupLines;
}

public map[str,list[list[int]]] createBlocks(list[str] lines) {
	map[str,list[list[int]]] blocks = ();
	
	for(int i <- [0 .. size(lines)-5]) {
		str block = lines[i];
		
		for(int j <- [1 .. 6]) {
			block += lines[i+j];
		}
		
		if(!(block in blocks)) {
			blocks += ( block : [[i..(i+6)]]);
		} else {
			blocks[block] += [[i..(i+6)]];
		}
	}
	return (block : blocks[block] | block <- blocks, size(blocks[block]) > 1);
}