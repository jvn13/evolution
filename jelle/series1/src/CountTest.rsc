module CountTest

import Count;
import List;
import IO;

loc project = |project://ProjectSize|;
list[str] linesOfOfFile = getProjectLoc(project);

test bool countLocForFileWith27LinesOfCode_return27() = size(linesOfOfFile) == 27;

test bool countLocForMethods_returnLines() {
	locsPerMeth = getLocPerMethod(project);
	return 6 in locsPerMeth && 8 in locsPerMeth && 5 in locsPerMeth && size(locsPerMeth) == 3;
}