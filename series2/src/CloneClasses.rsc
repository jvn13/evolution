module CloneClasses

import Analyzation;
import Helper;
import List;
import Map;

private str removeLastLine(str block, map[str, list[list[LineType]]] duplicates) {
	str subBlock = "";
	for(line <- take(BLOCK_SIZE - 1, duplicates[block][0])) {
		subBlock += line.val;
	}
	return subBlock;
}

private str removeFirstLine(list[list[LineType]] block) {
	str subBlock = "";
	for(int i <- [size(block[0]) - (BLOCK_SIZE - 1) .. BLOCK_SIZE]) {
		// println(size(duplicates[block][0]) - (BLOCK_SIZE - 1));
		subBlock += block[0][i].val;
	}
	return subBlock;
}

public map[str, list[list[LineType]]] createLargerCloneClasses(map[str, list[list[LineType]]] duplicates) {
	partialBlocks = (removeFirstLine(duplicates[clone]) : clone | clone <- duplicates);
	map[str, str] subsumedClasses = ();
	
	overlappingBlocks = dup(overlappingBlocks);
	
	for(block <- overlappingBlocks) {
		if(block in subsumedClasses) {
			block = subsumedClasses[block];
		}
		if(block in duplicates) {
			subString = removeLastLine(block, duplicates);
		
			if(subString in partialBlocks) {
				// println("\nkey found= <partialBlocks[subString]> : <block>");
				
				str originalCloneClassString = partialBlocks[subString];
				list[list[LineType]] originalCloneClass = [[]];
				if(partialBlocks[subString] in duplicates) {
					originalCloneClass = duplicates[partialBlocks[subString]];
				} else if(partialBlocks[subString] in subsumedClasses) {
					//println(subsumedClasses[partialBlocks[subString]]);
					originalCloneClassString = subsumedClasses[partialBlocks[subString]];
					
					// TODO: fix this!!!!!! 
					if(originalCloneClassString in duplicates) {
						originalCloneClass = duplicates[originalCloneClassString];
					}
				}
				
				/*
				TODO: fix error about different size
					if(overlapFileCheck(originalCloneClass, duplicates[block])) {}
				*/
				if(size(duplicates[block]) == size(originalCloneClass)) {
					cloneClass = combineClasses(originalCloneClass, duplicates[block]);
					cloneClassStr = getBlockString(cloneClass);
					
					// add superclass
					subsumedClasses += (partialBlocks[subString] : cloneClassStr, block : cloneClassStr);
					duplicates += (cloneClassStr : cloneClass);
					
					// remove subclasses
					duplicates = delete(duplicates, originalCloneClassString);
					duplicates = delete(duplicates, block);
					overlappingBlocks = drop(1, overlappingBlocks);
				}
			}
		
		}
	}
	return duplicates;
}

private str getBlockString(list[list[LineType]] block) {
	str blockStr = "";
	for(line <- block[0]) {
		blockStr += line.val;
	}
	return blockStr;
}

private bool overlapFileCheck(list[list[LineType]] cloneClass, list[list[LineType]] overlapingClass) {
	bool sameFile = true;
	for(int i <- [0 .. size(cloneClass)]) {
		for(int j <- [0 .. size(cloneClass[i])]) {
			if(cloneClass[i][j].file != overlapingClass[i][j].file) {
				sameFile = false;
				break;
			}
		}
	}
	return sameFile;
}

private list[list[LineType]] combineClasses(list[list[LineType]] cloneClass, list[list[LineType]] overlapingClass) {	
	return [dup(cloneClass[i] + overlapingClass[i]) | i <- [0 .. size(cloneClass)]];
}


public list[tuple[int, str]] getBiggestCloneClass(map[str, list[list[LineType]]] duplicates) {
	return [<size(duplicates[block]), block> | block <- duplicates];
}
