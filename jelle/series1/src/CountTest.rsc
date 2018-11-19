module CountTest

import Count;
import List;
import IO;

loc fileWithDuplicatesInside = |project://ProjectSize|;
list[str] linesOfOfFile = getProjectLoc(fileWithDuplicatesInside);

test bool countLocForFileWith10LinesOfCode_return10() = size(linesOfOfFile) == 17;

test bool countLocForMethods_returnLines() {
locsPerMeth = getLocPerMethod(fileWithDuplicatesInside);
return 6 in locsPerMeth && 8 in locsPerMeth && size(locsPerMeth) == 2;
}