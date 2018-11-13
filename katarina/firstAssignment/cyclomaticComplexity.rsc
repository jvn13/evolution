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
list[loc] visibleFilesInPath = toList(getFiles(path));
return complexityOfAProject(visibleFilesInPath);
}

public list[loc] getFiles(loc project) {
    return [f | f <- visibleFiles(project), f.extension == "java"];
}


//returns a list with the complexity per file and the last number of the list is the overall complexity
public list[int] complexityOfAProject(list[loc] files){
list[int] result = [];
for(file <- files){
	result += complexityOfAClass(file);
}
return result+sum(result);
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
 		int result = 0;
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

public Declaration getDeclaration(loc file){
	return createAstFromFile(file,true);
}
