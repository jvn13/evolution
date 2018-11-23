module Rating

import Helper;
import IO;
import Visualization;
import Analyzation;
import util::Math;
import List;
/*
	The SIG ratings are converted to the following integer ratings:
	++ 	-> 	5
	+		->	4
	o		->	3
	-		->	2
	--	->	1
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

public int getUnitRating(str name, list[int] values, tuple[int,int,int] boundaries) {
	RiskProfile risks = getUnitRisk(values, boundaries);
	printRiskProfile(name, risks);
	if(
		(risks.moderate <= 25) &&
		(risks.high <= 0) &&
		(risks.veryhigh <= 0)
	) {
		return 5;
	} else if(
		(risks.moderate <= 30) &&
		(risks.high <= 5) &&
		(risks.veryhigh <= 0)
	) {
		return 4;
	} else if(
		(risks.moderate <= 40) &&
		(risks.high <= 10) &&
		(risks.veryhigh <= 0)
	) {
		return 3;
	} else if(
		(risks.moderate <= 50) &&
		(risks.high <= 15) &&
		(risks.veryhigh <= 5)
	) {
		return 2;
	} else {
		return 1;
	}
}

public int getUnitCCRating(str name, list[tuple[int,int]] values, tuple[int,int,int] boundaries) {
	RiskProfile risks = getUnitCCRisk(values, boundaries);
	printRiskProfile(name, risks);
	if(
		(risks.moderate <= 25) &&
		(risks.high <= 0) &&
		(risks.veryhigh <= 0)
	) {
		return 5;
	} else if(
		(risks.moderate <= 30) &&
		(risks.high <= 5) &&
		(risks.veryhigh <= 0)
	) {
		return 4;
	} else if(
		(risks.moderate <= 40) &&
		(risks.high <= 10) &&
		(risks.veryhigh <= 0)
	) {
		return 3;
	} else if(
		(risks.moderate <= 50) &&
		(risks.high <= 15) &&
		(risks.veryhigh <= 5)
	) {
		return 2;
	} else {
		return 1;
	}
}

public RiskProfile getUnitCCRisk(list[tuple[int risk,int lines]] values, tuple[int,int,int] boundaries){

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
	return toPercentageCC(linesPerRiskRank);
}

public RiskProfile getUnitRisk(list[int] values, tuple[int,int,int] boundaries) {
	risks = riskProfile(0, 0, 0, 0);
	for(m <- values) {
		if(m <= boundaries[0]) {
			risks.low += 1;
		} else if(m <= boundaries[1]) {
			risks.moderate += 1;
		} else if(m <= boundaries[2]) {
			risks.high += 1;
		} else {
			risks.veryhigh += 1;
		}
	}
	return toPercentage(risks);
}

public int getVolumeRating(int volume) {
	kloc = volume/1000;
	if(kloc < 66) {
		return 5;
	} else if(kloc < 246) {
		return 4;
	} else if(kloc < 665) {
		return 3;
	} else if(kloc < 1310) {
		return 2;
	} else {
		return 1;
	}
}

public RiskProfile toPercentageCC(list[int] locPerRiskRank){
	risks = riskProfile(0,0,0,0);
	risks.low = round(toReal(locPerRiskRank[0])/toReal(sizeOfProject)*100);
	risks.moderate = round(toReal(locPerRiskRank[1])/toReal(sizeOfProject)*100);
	risks.high = round(toReal(locPerRiskRank[2])/toReal(sizeOfProject)*100);
	risks.veryhigh=round(toReal(locPerRiskRank[3])/toReal(sizeOfProject)*100);
	return risks;
} 

public RiskProfile toPercentage(RiskProfile risks) {
	total = risks.low + risks.moderate + risks.high + risks.veryhigh;
	risks.low = calculatePercentage(risks.low, total);
	risks.moderate = calculatePercentage(risks.moderate, total);
	risks.high = calculatePercentage(risks.high, total);
	risks.veryhigh = 100 - risks.low - risks.moderate - risks.high;
	return risks;
}