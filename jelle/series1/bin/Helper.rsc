module Helper

import util::Math;

data RiskProfile = riskProfile(
	int low,
	int moderate,
	int high,
	int veryhigh
);

data ScoresType = Scores(
	int volume,
	list[int] unitSize,
	list[int] unitCC,
	int duplicates,
	int redundants,
	real duplicatePercentage,
	real redundantPercentage,
	int unitParameters
);

public int calculatePercentage(int partial, int total) {
	return round(toReal(partial) / toReal(total)*100);
}