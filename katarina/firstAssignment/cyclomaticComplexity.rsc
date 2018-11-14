module cyclomaticComplexity
import List;
import analysis::m3::AST;
import analysis::m3::Core;
import lang::java::m3::AST;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Resources;
import IO;
import analysis::graphs::Graph;
import util::FileSystem;
import Set;
import Rank;


//path: path to a folder which contains (not only) java files
//returns a list with the complexity per unit and the last number of the list is the sum of the complexity of all units
public list[int] complexityOfAPath(loc path){
list[loc] visibleFilesInPath = getFiles(path);
return complexityOfAProject(visibleFilesInPath);
}



//returns a list with the complexity per file and the last number of the list is the overall complexity
public list[int] complexityOfAProject(list[loc] files){
list[int] result = [];
for(file <- files){
	result += complexityOfAClass(file);
}
return result;
}





//per file return complexity & number for each case of methods
public list[int] complexityOfAClass(loc file){

	list[int] result = [];
	Declaration decl = getDeclaration(file);
	visit(decl){
		case methodCase1:\method(_,_,_,_,_) : result += complexityPerMethod(methodCase1);
	}
	return result;
	}


private int complexityPerMethod(method){
 		int result = 1;
 			visit(method){
				case \if(_,_) : result += 1;
				case \if(_,_,_) : result += 1;
				case \for(_,_,_) : result +=1;
				case \for(_,_,_,_) : result +=1;
				case \case(_) : result +=1;
				case \while(_,_) : result +=1;
				case \foreach(_,_,_) : result +=1;
				case \catch(_,_) : result +=1;
				case infix(_,"&&",_) : result +=1;
				case infix(_,"||",_) : result +=1;

				} 
	return result;
}



public RiskProfile riskEvaluationOfAPath(loc file){
	
	list[int] complOfThePath = complexityOfAPath(file);
	return unitComplexityRisk(complOfThePath);
	
}


public list[loc] getFiles(loc project) {
    return [f | f <- visibleFiles(project), f.extension == "java"];
}

public Declaration getDeclaration(loc file){
	return createAstFromFile(file,true);
}

