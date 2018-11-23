module Rating

import Helper;
import IO;
import Visualization;

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

public RiskProfile toPercentage(RiskProfile risks) {
	total = risks.low + risks.moderate + risks.high + risks.veryhigh;
	risks.low = calculatePercentage(risks.low, total);
	risks.moderate = calculatePercentage(risks.moderate, total);
	risks.high = calculatePercentage(risks.high, total);
	risks.veryhigh = 100 - risks.low - risks.moderate - risks.high;
	return risks;
}