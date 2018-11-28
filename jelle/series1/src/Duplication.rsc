module Duplication

import IO;
import String;
import List;
import Set;
import Map;
import Visualization;

private int BLOCK_SIZE = 6;

/*
 * Finds the number of duplicate and redundant lines in a list of lines.
 *
 * @param lines - list of all source code lines of the project.
 * @return tuple[int, int] - tuple consisting of the number of duplication lines 
 *													 and the number of redundant lines.
 *
 */
public tuple[int, int] getDuplicateLinesPerProject(list[str] lines) {
	<duplicateBlocks, redundants> = getDuplicateBlocks(lines);
	set[int] duplicates = blockToLines(duplicateBlocks);
	return <size(duplicates), redundants>;
}

/*
 * Converts the duplicate blocks back to a set of duplicate lines.
 *
 * @param duplicateBlocks - map of the duplicate blocks with the string value as key
 *													and a list of a list of integers as value. The integers
 *													represent indices of the lines.
 * @return set[int] - set of indices of the duplicate lines.
 *
 */
private set[int] blockToLines(map[str,list[list[int]]] duplicateBlocks) {
	set[int] duplicates = {};
	for(block <- duplicateBlocks) {
		for(lines <- duplicateBlocks[block]) {
			duplicates += toSet(lines);
		}
	}
	return duplicates;
}

/*
 * Creates blocks of the BLOCK_SIZE out of the list of lines.
 * Appends blocks to a map where the string of the block is the key
 * and the list of indices of the block is appended to a list in the values.
 * Duplicate blocks have multiple lists as value in the map.
 *
 * @param lines - list of all source code lines of the project.
 * @return tuple[map[str, list[list[int]], int] - map of duplicate lines and int value of redundant lines.
 *
 */
private tuple[map[str,list[list[int]]], int] getDuplicateBlocks(list[str] lines) {
	map[str,list[list[int]]] blocks = ();
	int redundants = 0;
	bool inBlock = false;
	
	for(int i <- [0 .. size(lines) - (BLOCK_SIZE - 1)]) {
		str block = "";
		
		for(int j <- [0 .. BLOCK_SIZE]) block += lines[i + j];
		
		if(block in blocks) {
			blocks[block] += [[i .. (i + BLOCK_SIZE)]];
			
			if(inBlock) {
				redundants += 1;
			} else {
				redundants += BLOCK_SIZE;
				inBlock = true;
			}
		} else {
			blocks += ( block : [[i .. (i + BLOCK_SIZE)]]);
			inBlock = false;
		}
	}
	return <(block : blocks[block] | block <- blocks, size(blocks[block]) > 1), redundants>;
}