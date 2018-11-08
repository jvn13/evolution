module Analyze

import Count;
import IO;
import Read;
import lang::java::jdt::m3::Core;

public void main() {
	loc java_project = |project://BinaryConverter|;
	mmm = read(java_project);
	volume(java_project, mmm);
}

// Count the total lines of a project
public void volume(loc java_project, M3 mmm) {
	lines = countProjectLines(mmm);
	println("<java_project> : <lines>");
}