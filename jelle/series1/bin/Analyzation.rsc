module Analyzation

import CC;
import Count;
import Duplication;
import DuplicationTest;
import Helper;
import IO;
import List;
import Rating;
import util::Benchmark;
import util::Math;
import Visualization;

private void Analyze(loc project) {
	ScoresType scores = Scores(0,[],[],0, 0, 0.0, 0.0);
	lines = getProjectLoc(project);
	
	scores.volume = size(lines);
	scores.unitSize = getLocPerMethod(project);
	scores.unitCC = getCCPerMethod(project);
	<scores.duplicates, scores.redundants> = getDuplicateLinesPerProject(lines);
	scores.duplicatePercentage = round(scores.duplicates/ toReal(scores.volume)*100, 0.01);
	scores.redundantPercentage = round(scores.redundants/ toReal(scores.volume)*100, 0.01);
	
	ratings = composeRatings(scores);
	printInfo(scores, ratings);
}

private map[str,int] composeRatings(ScoresType scores) {
	return (
		"volume" : getVolumeRating(scores.volume),
	  "unitSize" : getUnitRating("Unit size", scores.unitSize, <15, 30, 60>),
	  "unitCC" : getUnitRating("Unit CC", scores.unitCC, <10, 20, 50>),
		"duplicates" : getDuplicationRating(scores.duplicates, scores.volume),
		"redundants" : getDuplicationRating(scores.redundants, scores.volume)
	);
}

public void Main() {
	loc project = |project://smallsql0.21_src|;
	//loc project = |project://series1/src/testfiles/temporary|;
	//loc project = |project://hsqldb-2.3.1|;
	
	time = realTime(void () {
		Analyze(project);
	});
	println("Execution time: <time> ms");
}