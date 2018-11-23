module CCTest

import CC;
import IO;
import List;
import String;


public bool ccTest(loc file, list[int] expectedResult) {
	result = getClassCC(file);
	println("Result = <result>");
	return result == expectedResult;
}
public test bool testTraverseMethodNestedIf(){	
return ccTest(|project://series1/src/testfiles/fileOrder/NestedIf.java|, [3]);
}

public test bool testCCForSwitchCase(){
return ccTest(|project://series1/src/testfiles/basicDuplication/File1.java|, [5,2,1]);
}

public test bool testCCForSmallSQL(){
return ccTest(|project://smallsql0.21_src/src/smallsql/database/ExpressionArithmetic.java|, [1,2]);
}