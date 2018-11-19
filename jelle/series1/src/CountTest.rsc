module CountTest

import Count;
import List;
import IO;

loc fileWithDuplicatesInside = |project://ProjectSize|;
list[str] linesOfOfFile = getProjectLoc(fileWithDuplicatesInside);

test bool countLocForFileWith27LinesOfCode_return27() = size(linesOfOfFile) == 27;

test bool countLocForMethods_returnLines() {
locsPerMeth = getLocPerMethod(fileWithDuplicatesInside);
return 6 in locsPerMeth && 8 in locsPerMeth && 5 in locsPerMeth && size(locsPerMeth) == 3;
}