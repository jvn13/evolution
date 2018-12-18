module CloneClasses

import Analyzation;
import Helper;
import List;
import Map;

/*
 * Creates a string of the first five line values of the block 
 */
private str removeLastLine(str block, map[str, list[list[LineType]]] duplicates) {
	str subBlock = "";
	for(line <- take(BLOCK_SIZE - 1, duplicates[block][0])) {
		subBlock += line.val;
	}
	return subBlock;
}

/*
 * Creates a string of the last five line values of the block 
 */
private str removeFirstLine(list[list[LineType]] block) {
	str subBlock = "";
	for(int i <- [size(block[0]) - (BLOCK_SIZE - 1) .. BLOCK_SIZE]) {
		subBlock += block[0][i].val;
	}
	return subBlock;
}

/*
 * Merges classes into larger classes if the larger class subsumes all the smaller ones
 */
public map[str, list[list[LineType]]] createLargerCloneClasses(map[str, list[list[LineType]]] duplicates) {
	partialBlocks = (removeFirstLine(duplicates[clone]) : clone | clone <- duplicates);
	map[str, str] subsumedClasses = ();
	
	overlappingBlocks = dup(overlappingBlocks);
	
	for(block <- overlappingBlocks) {
		if(block in subsumedClasses) block = subsumedClasses[block];
		if(block in duplicates) {
			str subString = removeLastLine(block, duplicates);
		
			if(subString in partialBlocks) {
				str originalCloneClassString = partialBlocks[subString];
				list[list[LineType]] originalCloneClass = getOriginalCloneClass(subString, partialBlocks, duplicates, originalCloneClassString, subsumedClasses);
				
				if(size(duplicates[block]) == size(originalCloneClass)) {
					cloneClass = combineClasses(originalCloneClass, duplicates[block]);
					cloneClassStr = getBlockString(cloneClass);
					
					subsumedClasses += (partialBlocks[subString] : cloneClassStr, block : cloneClassStr);
					duplicates += (cloneClassStr : cloneClass);
					
					duplicates = delete(duplicates, originalCloneClassString);
					duplicates = delete(duplicates, block);
					overlappingBlocks = drop(1, overlappingBlocks);
				}
			}
		
		}
	}
	return duplicates;
}

/*
 * Return the original clone class that matches the substring
 */
private list[list[LineType]] getOriginalCloneClass(str subString, map[str,str] partialBlocks, 
		map[str, list[list[LineType]]] duplicates, str originalCloneClassString, map[str, str] subsumedClasses) {
	list[list[LineType]] originalCloneClass = [[]];
	if(partialBlocks[subString] in duplicates) {
			originalCloneClass = duplicates[partialBlocks[subString]];
		} else if(partialBlocks[subString] in subsumedClasses) {
			originalCloneClassString = subsumedClasses[partialBlocks[subString]];
			if(originalCloneClassString in duplicates) {
				originalCloneClass = duplicates[originalCloneClassString];
			}
		}
	return originalCloneClass;
}

/*
 * Returns the string identifier of a block
 */
private str getBlockString(list[list[LineType]] block) {
	str blockStr = "";
	for(line <- block[0]) {
		blockStr += line.val;
	}
	return blockStr;
}

/*
 * Combines two clone classes into one large class
 */
private list[list[LineType]] combineClasses(list[list[LineType]] cloneClass, list[list[LineType]] overlapingClass) {	
	return [dup(cloneClass[i] + overlapingClass[i]) | i <- [0 .. size(cloneClass)]];
}

/*
 * Returns the clone class with the most occurences
 */
public tuple[int, str] getBiggestCloneClass(map[str, list[list[LineType]]] cloneClasses) {
	return last(sort([<size(cloneClasses[cloneClass]), cloneClass> | cloneClass <- cloneClasses]));
}

/*
 * Returns the clone class with the most lines
 */
public tuple[int, str] getBiggestClone(map[str, list[list[LineType]]] cloneClasses) {
	return last(sort([<size(cloneClasses[cloneClass][0]), cloneClass> | cloneClass <- cloneClasses]));
}
