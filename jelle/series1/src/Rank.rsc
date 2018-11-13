module Rank

import IO;
import util::Math;

data RiskProfile = riskProfile(
	int low,
	int moderate,
	int high,
	int veryhigh
);

public int volumeRank(int volume) {
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

public RiskProfile unitSizeRisk(list[int] unit_sizes) {
	risks = riskProfile(0, 0, 0, 0);
	
	for(m <- unit_sizes) {
		if(m < 10) {
			risks.low += 1;
		} else if(m < 100) {
			risks.moderate += 1;
		} else if(m < 200) {
			risks.high += 1;
		} else {
			risks.veryhigh += 1;
		}
	}
	
	risks = toPercentage(risks);
	
	return risks;
}

public int unitSizeRank(RiskProfile risks) {
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