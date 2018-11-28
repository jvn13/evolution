module CC

import lang::java::jdt::m3::AST;
import Read;
import IO;
import List;
import Count;
import analysis::m3::AST;

/*
 * returns a list that contains cyclomatic complexity & number of lines per method
 *
 * @ param loc - path of a project
 */
public list[tuple[int,int]] getCCPerMethod(loc project){
	list[loc] files = getFiles(project);
	list[tuple[int,int]] result = [];
	for(f <- files) result += getClassCC(f);
	return result;
}

/*
 * returns a list that contains cyclomatic complexity & number of lines per method
 *
 * @ param loc - path of a file / class
 */
public list[tuple[int,int]] getClassCC(loc file){
	list[tuple[int,int]] result = [];
	Declaration decl = createAstFromFile(file, false);
	
	visit(decl){
		case methodCase:\method(_,_,_,_,_) : result += <getMethodCC(methodCase), size(getLoc(methodCase.src))>;
	}
	return result;
}

/*
 * visits each node and increases the cyclomatic complexity of the method by 1 in case of an if, for, ...
 *
 * @ param meth - declaration of the method to analyse
 */
public int getMethodCC(Declaration meth){
	int result = 1;
	
	visit(meth){
		case \if(_,_) : result += 1;
		case \if(_,_,_) : result += 1;
		case \conditional(_,_,_): result +=1;
		case \for(_,_,_) : result += 1;
		case \for(_,_,_,_) : result += 1;
		case \case(_) : result += 1;
		case \while(_,_) : result += 1;
		case \foreach(_,_,_) : result += 1;
		case \catch(_,_) : result += 1;
		case \infix(_,"&&",_) : result += 1;
		case \infix(_,"||",_) : result += 1;
	} 
	return result;
}