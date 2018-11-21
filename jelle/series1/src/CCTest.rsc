module CCTest

import CC;
import IO;
import List;
import String;


public test bool testTraverseMethodNestedIf(){	
loc locationFile = |project://series1/src/testfiles/fileOrder/NestedIf.java|;
	result = getClassCC(locationFile);
	return result == [3];
}