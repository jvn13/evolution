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
	list[tuple[int,int]] unitCC,
	int duplicates,
	int redundants,
	real duplicatePercentage,
	real redundantPercentage,
	list[int] unitInterfacing
);

public int calculatePercentage(int partial, int total) {
	return round(toReal(partial) / toReal(total)*100);
}