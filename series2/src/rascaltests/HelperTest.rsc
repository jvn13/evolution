module rascaltests::HelperTest

import Helper;
import List;

test bool getFilesOfProjectLoc_ReturnsAllJavaFiles(){
	project = |project://series2/src|;
	files = getFiles(project);
	return size(files) == 12;
}