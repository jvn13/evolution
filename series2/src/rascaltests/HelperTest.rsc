module rascaltests::HelperTest

import Helper;

test bool getFilesOfProjectLoc_ReturnsAllJavaFiles(){
	projectLoc = |project://series2/src|;
	files = getFiles(projectLoc);
	return size(files)==12;
}