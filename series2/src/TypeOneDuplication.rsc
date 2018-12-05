module TypeOneDuplication

import Helper;
import IO;
import String;
import List;
import Set;
import Map;

private int BLOCK_SIZE = 6;
public tuple[int lines, int geenidee] typeOne = <0, 0>;

/*
 * Finds the number of duplicate and redundant lines in a list of lines.
 *
 * @param lines - list of all source code lines of the project.
 * @return tuple[int, int] - tuple consisting of the number of duplication lines 
 *													 and the number of redundant lines.
 *
 */
public map[str, list[list[LineType]]] getDuplicateLinesPerProject(list[LineType] lines) {
	map[str, list[list[LineType]]] duplicateBlocks = getDuplicateBlocks(lines);
	typeOne.lines = getNumberOfDuplicates(duplicateBlocks);
	return duplicateBlocks;
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
private int getNumberOfDuplicates(map[str,list[list[LineType]]] duplicateBlocks) {
	set[LineType] duplicates = {};
	for(block <- duplicateBlocks) {
		for(lines <- duplicateBlocks[block]) {
			duplicates += toSet(lines);
		}
	}
	return size(duplicates);
}

/*
 * Creates blocks of the BLOCK_SIZE out of the list of lines.
 * Appends blocks to a map where the string of the block is the key
 * and the list of indices of the block is appended to a list in the values.
 * Duplicate blocks have multiple lists as value in the map.
 *
 * @param lines - list of all source code lines of the project.
 * @return map[str, list[list[int]] - map of duplicate lines.
 *
 */
private map[str,list[list[LineType]]] getDuplicateBlocks(list[LineType] lines) {
	map[str,list[list[LineType]]] blocks = ();
	if(size(lines) >= BLOCK_SIZE){
	for(int i <- [0 .. size(lines) - (BLOCK_SIZE - 1)]) {
		str block = "";
		
		list[LineType] linesInBlock = [lines[i + j] | j <- [0 .. BLOCK_SIZE]];
		
		for(line <- linesInBlock) block += line.val;
		
		if(block in blocks) {
			blocks[block] += [linesInBlock];
		} else {
			blocks += ( block : [linesInBlock]);
		}
	}
	return (block : blocks[block] | block <- blocks, size(blocks[block]) > 1);
	}
	return blocks;
}