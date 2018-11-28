module Rating

import Analyzation;
import Helper;
import IO;
import List;
import Visualization;
import util::Math;

public tuple[int plusplus, int plus, int neutral, int minus] VOLUME_BOUNDARIES = <66, 246, 665, 1310>;

/*
 *  The SIG ratings are converted to the following integer ratings:
 *  ++  ->  5
 *  +   ->  4
 *  o   ->  3
 *  -   ->  2
 *  --  ->  1
 *
 */
 
/*
 * Convertes the volume into a rating of the SIG model.
 *
 * @param volume - number of source code lines.
 * @return int - SIG duplciation rating 
 *
 */
public int getVolumeRating(int volume) {
	kloc = volume/1000;
	if(kloc < VOLUME_BOUNDARIES.plusplus) {
		return 5;
	} else if(kloc < VOLUME_BOUNDARIES.plus) {
		return 4;
	} else if(kloc < VOLUME_BOUNDARIES.neutral) {
		return 3;
	} else if(kloc < VOLUME_BOUNDARIES.minus) {
		return 2;
	} else {
		return 1;
	}
}

/*
 * Convertes the number of duplicate lines into a rating of the SIG model.
 *
 * @param duplicates - int of duplicate lines.
 * @param volume - int of total source code lines.
 * @return int - SIG duplciation rating 
 *
 */
public int getDuplicationRating(int duplicates, int volume) {
	int percentage = calculatePercentage(duplicates, volume);
	if(percentage <= 3) {
		return 5;
	} else if(percentage <= 5) {
		return 4;
	} else if(percentage <= 10) {
		return 3;
	} else if(percentage <= 20) {
		return 2;
	} else {
		return 1;
	}
}

/*
 * Handles the conversion of Unit complexity, size and interfaces into a SIG rating.
 * First calls a method to obtain the riskprofile of the metric result.
 * 
 * @param name - the name of the metric (used to pretty print the risks).
 * @param values - the obtained results of the metric in a list[tuple[int,int]].
 *								 each tuple represents one method. The first value of the tuple is
 *								 the metric value while the second one is the method size.
 * @param boundaries - values that form the boundaries for the low, moderate and high risks.
 * @return int - SIG duplciation rating 
 *
 */
public int getUnitRating(str name, list[tuple[int,int]] values, tuple[int,int,int] boundaries) {
	RiskProfile risks = getUnitRisk(values, boundaries);
	printRiskProfile(name, risks);
	if( (risks.moderate <= 25) && (risks.high <= 0) && (risks.veryhigh <= 0) ) {
		return 5;
	} else if( (risks.moderate <= 30) && (risks.high <= 5) && (risks.veryhigh <= 0) ) {
		return 4;
	} else if( (risks.moderate <= 40) && (risks.high <= 10) && (risks.veryhigh <= 0) ) {
		return 3;
	} else if( (risks.moderate <= 50) && (risks.high <= 15) && (risks.veryhigh <= 5) ) {
		return 2;
	} else {
		return 1;
	}
}

/*
 * TODO
 *
 * @param values -
 * @param boundaries - 
 * @return RiskProfile - 
 *
 */
public RiskProfile getUnitRisk(list[tuple[int risk,int lines]] values, tuple[int,int,int] boundaries){
	linesPerRiskRank = [0,0,0,0];
	for(m <- values){
		if(m.risk <= boundaries[0]) {
			linesPerRiskRank[0] += m.lines;
		} else if(m.risk <= boundaries[1]) {
			linesPerRiskRank[1] +=m.lines;
		} else if(m.risk <= boundaries[2]) {
			linesPerRiskRank[2] +=m.lines;
		} else {
			linesPerRiskRank[3] +=m.lines;
		}
	}
	return toPercentage(linesPerRiskRank);
}

/*
 * TODO
 *
 * @param locPerRiskRank - 
 * @return RiskProfile - 
 * 
 */
public RiskProfile toPercentage(list[int] locPerRiskRank){
	risks = riskProfile(0,0,0,0);
	real volume = toReal(scores.volume);
	risks.low = round(locPerRiskRank[0] / volume * 100);
	risks.moderate = round(locPerRiskRank[1] / volume * 100);
	risks.high = round(locPerRiskRank[2] / volume * 100);
	risks.veryhigh=round(locPerRiskRank[3] / volume * 100);
	return risks;
}