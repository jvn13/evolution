module Count

import IO;
import List;
import lang::java::jdt::m3::Core;

public int countAllLines(list[str] classSrc) {
  return size(classSrc);
}

public int countBlankLines(list[str] classSrc) {
  n = 0;
  for(line <- classSrc) {
    if(/^[ \t\r\n]*$/ := line)
      n += 1;
  }
  return n;
}

public list[int] countMethodLines(M3 mmm, lrel[str,int] comments) {
  dec = mmm.declarations;
  lines = [];
  for(d <- dec){
    if(isMethod(d.name)){
      begin_line = d.src.begin.line;
      end_line = d.src.end.line;
      blank = countBlankLines(readFileLines(d.src));
      comment = size([l | <f,l> <- comments, 
        f == d.src.file && l >= begin_line && l <= end_line]);
      lines += [end_line - begin_line + 1 - blank - comment];
    }
  }
  return lines;
}

public int countProjectLines(M3 mmm, int comments) {
  lines = 0;
  for(c <- classes(mmm)) {
    src = readFileLines(c);
    total = countAllLines(src);
    blank = countBlankLines(src);
    lines += total - blank;
  }
  lines -= comments;
  return lines;
}