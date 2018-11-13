module duplication

import IO;
import String;
import List;
import Set;
import util::Math;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

list[set[int]] getNumberOfDuplicatedBlocksInAFile(loc project){
list[str] linesOfTheFile = getAllLinesFromModel(createM3FromEclipseProject(project));
map[str,set[int]] mapOfLinesAndIndices =toMap(zip(linesOfTheFile, index(linesOfTheFile))); //get a map which maps each line with a index
map[str,set[int]] mapOfDuplicates = (line : mapOfLinesAndIndices[line]|line<-mapOfLinesAndIndices, size(mapOfLinesAndIndices[line])>1); //potential duplicates
list[set[int]] linesOfduplicates = toList({lineIndices| 
					line <- mapOfDuplicates, 
					lineIndices := mapOfDuplicates[line]}); //returns a list of all indices which contain duplicates
					

//split list as long as it is not empty -> get blocks of following numbers -> pick the ones that are size>=6->count			
return linesOfduplicates;
}


list[str] getAllLinesFromModel(M3 model) {
    set[loc] classes = classes(model);
    list[str] allLines = [];
    
    for (class <- classes) {
        list [str] classLines = readFileLines(class);
        allLines += classLines;
    }
    
    return [trim(line) | line <- allLines]; //remove leading spaces
}



//readFileLines-removewhites-check for duplicates and check if >6 indices are following