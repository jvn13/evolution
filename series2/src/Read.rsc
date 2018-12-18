module Read

import IO;
import lang::java::jdt::m3::Core;
import util::FileSystem;

/*
 * Returns the files in the project that have a ".java" extension.
 */
public list[loc] getFiles(loc project) {
	return [f | f <- visibleFiles(project), f.extension == "java"];
}

/*
 * Creates a M3 model of the project and returns it.
 */
public M3 read(loc java_project) {
	mmm = createM3FromEclipseProject(java_project);
	return mmm;
}