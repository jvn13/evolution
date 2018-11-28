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

public ScoresType scores = Scores(0, [] ,[] ,0, 0, 0.0, 0.0, []);

/*
 * Runs the analyzation for the smallsql project
 *
 */
public void runSmallSQL() {
	loc project = |project://smallsql0.21_src|;
	runAnalyzation(project);
}

/*
 * Runs the analyzation for the hsql project
 *
 */
public void runHsql() {
	loc project = |project://hsqldb-2.3.1|;
	runAnalyzation(project);
}

/*
 * Runs the analyzation for the provided project
 * and keeps track of the duration of the execution.
 * 
 * @ param project - location of the project to analyze.
 *
 */
public void runAnalyzation(loc project) {
	time = realTime(void () {
		Analyze(project);
	});
	println("Execution time: <time> ms");
}

/*
 * Calculates all the desired metrics and ratings for the project.
 * Calls a function to pretty print the results.
 *
 * @param project - location of the project.
 *
 */
private void Analyze(loc project) {
	lines = getProjectLoc(project);
	
	scores.volume = size(lines);
	scores.unitInterfaces = getInterfaceAndLocPerMethod(project);
	scores.unitSize = [<e,e> | <_,e> <- scores.unitInterfaces];
	scores.unitCC = getCCPerMethod(project);
	<scores.duplicates, scores.redundants> = getDuplicateLinesPerProject(lines);
	scores.duplicatePercentage = round(scores.duplicates/ toReal(scores.volume)*100, 0.01);
	scores.redundantPercentage = round(scores.redundants/ toReal(scores.volume)*100, 0.01);
	
	ratings = composeRatings(scores);
	printInfo(scores, ratings);
}

/*
 * Calculates the ratings for the desired metrics.
 *
 * @param scores - collection of all the absolute scores.
 * @return map(metric, rating)
 *
 */
private map[str,int] composeRatings(ScoresType scores) {
	return (
		"volume" : getVolumeRating(scores.volume),
		"unitSize" : getUnitRating("Unit size", scores.unitSize, <15, 30, 60>),
	  "unitCC" : getUnitRating("Unit CC", scores.unitCC, <10, 20, 50>),
		"duplicates" : getDuplicationRating(scores.duplicates, scores.volume),
    "redundants" : getDuplicationRating(scores.redundants, scores.volume),
    "unitInterfaces" : getUnitRating("Unit interfaces", scores.unitInterfaces, <2, 4, 6>)
	);
}