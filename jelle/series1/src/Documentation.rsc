module Documentation

import lang::java::jdt::m3::Core;
import List;

public lrel[str,int] getDocumentation(M3 mmm) {
  comments = [];
  for(d <- mmm.documentation){
    c = d.comments;
    for(int i <- [c.begin.line .. c.end.line+1]){
      comments = comments + [<c.file,i>];
    }
  }
  return comments;
}