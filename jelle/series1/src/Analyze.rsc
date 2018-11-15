module Analyze

import CC;
import Count;
import Duplication;
import Helper;
import IO;
import List;
import Rating;
import util::Benchmark;
import Visualization;

public void Analyze(loc project) {
	ScoresType scores = Scores(0,[],[],0);
	lines = getProjectLoc(project);
	
	scores.volume = size(lines);
	scores.unitSize = getLocPerMethod(project);
	scores.unitCC = complexityOfAProject(project);
	scores.duplicates = duplicates(lines);
	
	ratings = composeRatings(scores);
	printInfo(scores, ratings);
}

public map[str,int] composeRatings(ScoresType scores) {
	return (
		"volume" : getVolumeRating(scores.volume),
	  "unitSize" : getUnitRating(scores.unitSize, <10, 100, 200>),
	  "unitCC" : getUnitRating(scores.unitCC, <10, 20, 50>),
		"duplicates" : getDuplicationRating(scores.duplicates, scores.volume)
	);
}

public void Main() {
	 loc project = |project://smallsql0.21_src|;
	//loc project = |project://BinaryConverter|;
	//loc project = |project://hsqldb-2.3.1|;
	
	time = realTime(void () {
		Analyze(project);
	});
	println("Execution time: <time> ms");
}