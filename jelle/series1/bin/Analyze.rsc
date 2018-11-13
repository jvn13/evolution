module Analyze

import Count;
import Documentation;
import IO;
import List;
import Rank;
import Read;
import lang::java::jdt::m3::Core;

public void main() {
	 loc java_project = |project://smallsql0.21_src|;
	//loc java_project = |project://BinaryConverter|;
	mmm = read(java_project);
	countMetrics(mmm);
}

public void countMetrics(M3 mmm){
	comments = getDocumentation(mmm);
	println("Metric \t\tValue \tRank");
	println("------------------------------");
	// Volume
	volume = countProjectLines(mmm, size(comments));
	volume_rank = volumeRank(volume);
	println("Volume: \t<volume> \t<volume_rank>");
	// Unit size
	unit_sizes = countMethodLines(mmm, comments);
	unit_size_risk = unitSizeRisk(unit_sizes);
	unit_size_rank = unitSizeRank(unit_size_risk);
	println("Unit size: \t<sum(unit_sizes)/size(unit_sizes)> \t<unit_size_rank>");
}