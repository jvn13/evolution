module rascaltests::AnalyzationTest

import Count;
import Helper;
import Analyzation;
import IO;

test bool generateFileWithCloneClasses(){
	map[str, list[list[LineType]]] cloneClasses = ();

	loc projLoc = |project://series2/src/Analyzation.rsc|;
	cloneClasses += ("String ":[getLoc(projLoc)]);

	writeExportFile(projLoc, cloneClasses);
	
	destination = |project://series2/src/series2_result.txt|;
	return exists(destination) && readFile(destination) != "";
}