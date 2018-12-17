module rascaltests::AnalyzationTest

import Count;
import Helper;
import Analyzation;
import IO;

loc projLoc = |project://series2/src/Analyzation.rsc|;
loc destination = |project://series2/src/series2_result.txt|;

void initializeGlobalVariables(loc projLoc){
CLONE_CLASSES = ("Test String ":[getLoc(projLoc)]);
}

void deinitializeGlobalVariables(loc projLoc){
CLONE_CLASSES = ();
}

test bool writeFileWithCloneClasses_FileExistsAndIsNotEmpty(){
	
	initializeGlobalVariables(projLoc);
	writeExportFile(projLoc);
	deinitializeGlobalVariables(projLoc);
	
	return exists(destination) && readFile(destination) != "";
}

test bool writeFileWithCloneClasses_FileExistsButIsEmpty(){	
	writeExportFile(projLoc);		
	return exists(destination) && readFile(destination) == "";
}