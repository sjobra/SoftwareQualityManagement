module Utilities

public str determineRanking(int level)
{
	switch(level)
	{
		case 0:
			return "--";
		case 1:
			return "-";
		case 2:
			return "+/-";
		case 3:
			return "+";
		case 4: 
			return "++";
	}
}