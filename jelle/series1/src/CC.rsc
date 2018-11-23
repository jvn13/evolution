module CC

import lang::java::jdt::m3::AST;
import Read;

//returns a list with the complexity per file
public list[int] getCCPerMethod(loc project){
	list[loc] files = getFiles(project);
	list[int] result = [];
	for(f <- files) result += getClassCC(f);
	return result;
}

//per file return complexity & number for each case of methods
public list[int] getClassCC(loc file){
	list[int] result = [];
	Declaration decl = getDeclaration(file);
	
	visit(decl){
		case methodCase:\method(_,_,_,_,_) : result += getMethodCC(methodCase);
	}
	return result;
}

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
		case infix(_,"&&",_) : result += 1;
		case infix(_,"||",_) : result += 1;
	} 
	return result;
}

public Declaration getDeclaration(loc file){
	return createAstFromFile(file, false);
}