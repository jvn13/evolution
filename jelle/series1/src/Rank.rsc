module Rank

import IO;
import util::Math;

data RiskProfile = riskProfile(
	int low,
	int moderate,
	int high,
	int veryhigh
);

public int getVolumeRank(int volume) {
	kloc = volume/1000;
	
	if(kloc < 66) {
		return 5;
	} else if(kloc < 246) {
		return 4;
	} else if(kloc < 246) {
		return 3;
	} else if(kloc < 246) {
		return 2;
	} else {
		return 1;
	}
}

public int getDuplicationRank(int percentage) {
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

public int calculatePercentage(int partial, int total) {
	return round(toReal(partial) / toReal(total)*100);
}

public RiskProfile toPercentage(RiskProfile risks) {
	total = risks.low + risks.moderate + risks.high + risks.veryhigh;
	risks.low = calculatePercentage(risks.low, total);
	risks.moderate = calculatePercentage(risks.moderate, total);
	risks.high = calculatePercentage(risks.high, total);
	risks.veryhigh = 100 - risks.low - risks.moderate - risks.high;
	return risks;
}

public str rankToSymbol(int rank) {
	switch(rank) {
		case 5: return "++";
		case 4: return "+";
		case 3: return "o";
		case 2: return "-";
		case 1: return "--";
	}	
}

public RiskProfile unitRisk(list[int] values, tuple[int,int,int] boundaries) {
	risks = riskProfile(0, 0, 0, 0);
	
	for(m <- values) {
		if(m < boundaries[0]) {
			risks.low += 1;
		} else if(m < boundaries[1]) {
			risks.moderate += 1;
		} else if(m < boundaries[2]) {
			risks.high += 1;
		} else {
			risks.veryhigh += 1;
		}
	}
	
	risks = toPercentage(risks);
	
	return risks;
}

public int getUnitRank(RiskProfile risks) {
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