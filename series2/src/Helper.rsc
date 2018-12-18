module Helper

import IO;
import lang::java::jdt::m3::Core;
import util::FileSystem;

/*
 * TODO
 */
data LineType = Line(
	loc file,
	int index,
	str val
);

/*
 * TODO
 */
public list[loc] getFiles(loc project) {
	return [f | f <- visibleFiles(project), f.extension == "java"];
}

/*
 * TODO
 */
public M3 read(loc java_project) {
	mmm = createM3FromEclipseProject(java_project);
	return mmm;
}