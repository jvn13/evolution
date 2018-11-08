module Read

import IO;
import List;
import Set;
import util::Resources;
import lang::java::jdt::m3::Core;

// list[loc] projects_list = getAllProjects();
public list[loc] getAllProjects(){
  return toList(projects());
}

public M3 read(loc java_project) {
	mmm = createM3FromEclipseProject(java_project);
	return mmm;
}