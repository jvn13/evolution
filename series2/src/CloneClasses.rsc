module CloneClasses

private str removeBlockLine(list[LineType] block, int lineIndex) {
  block = delete(block, lineIndex);
  str subBlock = "";
  for(line <- block) {
    subBlock += line.val;
  }
  return subBlock;
}

public void getCloneClasses(map[str, list[list[LineType]]] duplicates) {
  beforeMap = (removeBlockLine(duplicates[clone][0], 0) : clone | clone <- duplicates);
  afterMap = (removeBlockLine(duplicates[clone][0], size(duplicates[clone][0]) - 1) : clone | clone <- duplicates);
  
  println();
  for(clone <- duplicates) {
    lastSubStr = removeBlockLine(duplicates[clone][0], 0);
    firstSubStr = removeBlockLine(duplicates[clone][0], size(duplicates[clone][0]) - 1);
    
    if(firstSubStr in beforeMap) {
      println("before = <firstSubStr> : <clone>");
    }
    
    if(lastSubStr in afterMap) {
      println("after = <firstSubStr> : <clone>");
    }
  }
}

public void getCloneClasses(map[str, list[list[LineType]]] duplicates) {
	subBlocks = (removeBlockLine(duplicates[clone][0], size(duplicates[clone][0]) - 1) : clone | clone <- duplicates);
	
	for(clone <- duplicates) {
		println("\n* <clone>");
		cloneClass = duplicates[clone];
		subBlock = removeBlockLine(cloneClass[0], 0);
		
		if(subBlock in subBlocks) {
			overlapingCloneClass = duplicates[subBlocks[subBlock]];
			// check for same size
			if(size(cloneClass) == size(overlapingCloneClass)) {
				println("<clone> : <subBlocks[subBlock]>");
				
				// Check if the overlaping blocks are in the same file
				if(overlapFileCheck(cloneClass, overlapingCloneClass)) {
					// cloneClasses += 
					println(combineClasses(cloneClass, overlapingCloneClass));
				}
			}
		}
	}
}

private list[list[LineType]] combineClasses(list[list[LineType]] cloneClass, list[list[LineType]] overlapingClass) {	
	return [dup(cloneClass[i] + overlapingClass[i]) | i <- [0 .. size(cloneClass)]];
}

public bool overlapFileCheck(list[list[LineType]] cloneClass, list[list[LineType]] overlapingClass) {
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