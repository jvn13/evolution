module rascaltests::AnalyzationTest

import Analyzation;
import Count;
import Helper;
import IO;

private loc projLoc = |project://series2/src/Analyzation.rsc|;
private loc destination = |project://series2/src/series2_result.txt|;

private void initializeGlobalVariables(loc projLoc){
	CLONE_CLASSES = ("Test String ":[getLoc(projLoc)]);
}

private void deinitializeGlobalVariables(loc projLoc){
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