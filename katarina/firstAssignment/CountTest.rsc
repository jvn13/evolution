module CountTest

import Count;
import List;

loc fileWithNoDuplicatesInside = |project://series1/src/testfiles/ClassWithoutDuplicateBlocks.java|;
list[str] linesOfOfFile = getProjectLoc(fileWithNoDuplicatesInside);

test bool countLocForFileWith13LinesOfCode_return13() = size(linesOfOfFile) == 13;