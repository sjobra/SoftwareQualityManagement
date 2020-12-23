module Maintainability

import util::Math;

public int getAnalysability(int volume, int duplication, int unitSize)
{
	return round((volume + duplication + unitSize) / 3);
}

public int getChangability(int unitComplexity, int duplication)
{
	return round((unitComplexity + duplication) / 2);
}

public int getTestability(int unitComplexity, int unitSize)
{
	return round((unitComplexity + unitSize) / 2);
}

public int getMaintainability(int analysability, int changeability, int testability)
{
	return round((analysability + changeability + testability) / 3);
}