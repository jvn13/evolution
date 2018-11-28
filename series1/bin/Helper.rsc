module Helper

import List;
import util::Math;

data RiskProfile = riskProfile(
	int low,
	int moderate,
	int high,
	int veryhigh
);

data ScoresType = Scores(
	int volume,
	list[tuple[int,int]] unitSize,
	list[tuple[int,int]] unitCC,
	int duplicates,
	int redundants,
	real duplicatePercentage,
	real redundantPercentage,
	list[tuple[int,int]] unitInterfaces
);

public real calculateAverage(list[tuple[int,int]] scores) {
	scoreSum = sum([e | <e,_> <- scores]);
	scoreSize = size(scores);
	return round(scoreSum / toReal(scoreSize), 0.001);
}

public int calculatePercentage(int partial, int total) {
	return round(toReal(partial) / toReal(total) * 100);
}