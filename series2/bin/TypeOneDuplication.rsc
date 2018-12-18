module TypeOneDuplication

import Analyzation;
import Helper;
import IO;
import String;
import List;
import Set;
import Map;

public int BLOCK_SIZE = 6;

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
	typeOne = getNumberOfDuplicates(duplicateBlocks);
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
public int getNumberOfDuplicates(map[str,list[list[LineType]]] duplicateBlocks) {
	set[LineType] duplicates = {};
	for(block <- duplicateBlocks) {
		for(blockLines <- duplicateBlocks[block]) {
			duplicates += toSet(blockLines);
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
	if(size(lines) >= BLOCK_SIZE) {
		bool duplicateFound = false;
		for(int i <- [0 .. size(lines) - (BLOCK_SIZE - 1)]) {
			str block = "";
			
			list[LineType] linesInBlock = [lines[i + j] | j <- [0 .. BLOCK_SIZE]];
			
			for(line <- linesInBlock) block += line.val;
			
			if(checkIfBlockInSameFile(linesInBlock)) {
			
			
				if(block in blocks) {
					blocks[block] += [linesInBlock];
					if(duplicateFound) {
						overlappingBlocks += [block];
					}
					duplicateFound = true;
				} else {
					blocks += ( block : [linesInBlock]);
					duplicateFound = false;
				}
				
			
			}
		}
		return (block : blocks[block] | block <- blocks, size(blocks[block]) > 1);
	}
	return blocks;
}

/*
 * Checks if the block does not overlap from one file into another.
 */
private bool checkIfBlockInSameFile(list[LineType] linesInBlock) {
	files = dup([l.file | l <- linesInBlock]);
	return size(files) == 1;
}