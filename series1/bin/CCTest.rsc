module CCTest

import CC;
import IO;
import List;
import String;

/*
 * helper function which calls a method to get the cyclomatic complexity of a project and compares that to an expected result
 *
 * @ param loc - path of file to analyse, 
 * expectedResults - tuples of expected cc and number of lines per method in the file
 * 
 */
public bool ccTest(loc file, list[tuple[int,int]] expectedResult) {
	return  getClassCC(file) == expectedResult;
}
public test bool testCCForNestedIf_returnComplexityThatConsidersEachIf(){	
return ccTest(|project://series1/src/testfiles/fileOrder/NestedIf.java|, [<3,9>]);
}

public test bool testCCForDifferentSwitchCases_returnComplexityOfEachMethod(){
return ccTest(|project://series1/src/testfiles/basicDuplication/File1.java|, [<5,13>,<2,7>,<1,3>]);
}

public test bool testCCForMethodsWithOutStatements_returnComplexity1(){
return ccTest(|project://series1/src/testfiles/sameFiles/File1.java|, [<1,7>,<1,7>, <1,7>]);
}