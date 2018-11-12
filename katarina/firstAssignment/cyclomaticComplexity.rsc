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

//path: path to a folder which contains java files
//returns a list with the complexity per file and the last number of the list is the overall complexity
public list[int] complexityOfAPath(loc path){
list[loc] visibleFilesInPath = toList(visibleFiles(path));
return complexityOfAProject(visibleFilesInPath);
}


//returns a list with the complexity per file and the last number of the list is the overall complexity
public list[int] complexityOfAProject(list[loc] files){
list[int] result = [];
for(file <- files){
	result += complexityOfAClass(file);
}
return result+sum(result);
}



//per file return complexity & number for each case of methods @TODO check for other patterns
//index 0: sum
//index 1: if
//index 2: for
//index 3: case
//index 4: while
//index 5: foreach
//index 6; catch
//index 7: infix
public list[int] complexityOfAClass(loc file){
int countIfs = 0;
int countFor = 0;
int countCase = 0;
int countWhile = 0;
int countForeach = 0;
int countCatch = 0;
int countInfix = 0;

Declaration declarationOfFile = getDeclaration(file);

visit(declarationOfFile){
	case \if(_,_) : countIfs += 1;
	case \if(_,_,_) : countIfs += 1;
	case \for(_,_,_) : countFor +=1;
	case \for(_,_,_,_) : countFor +=1;
	case \case(_) : countCase +=1;
	case \while(_,_) : countWhile +=1;
	case \foreach(_,_,_) : countForeach +=1;
	case \catch(_,_) : countCatch +=1;
	case infix(_,"&&",_) : countInfix +=1;
	case infix(_,"||",_) : countInfix +=1;

	} 
	//return [countIfs+countFor+countCase+countWhile+countForeach+countCatch+countInfix,countIfs,countFor, countCase, countWhile, countForeach, countCatch, countInfix];
	return [countIfs+countFor+countCase+countWhile+countForeach+countCatch+countInfix];

}

public Declaration getDeclaration(loc file){
	return createAstFromFile(file,true);
}