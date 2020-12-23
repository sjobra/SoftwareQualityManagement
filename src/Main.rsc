module Main

import IO;

import ProjectReader;
import LinesOfCode;
import MethodVolume;
import Duplication;
import CyclomaticComplexity;
import Utilities;
import Maintainability;

public void main()
{
	println("Project: smallSQL");
	println("----");	
	int linesOfCode = getLinesOfCodeProgram();
	println("lines of code : <linesOfCode>"  );
	println("number of units: <getTotalAmountOfMethods()>");
	
	println("unit size");
	map[str, real] volumeResults = cuv();
	printVolume(volumeResults);
	
	println("unit complexity");
	list[tuple[loc, str, int, int]] CC = calculateCyclomaticComplexity();
	printEvalCC(CC);
	
	// Quick version without Calculation
	//as();
	// Slow version with calculation
	// println(<duplication()>);
	int duplPercentage = getPercentage();
	duplication();
	println("");
	
	// Evaluation Part
	int rankingLoc = rankingLOC(linesOfCode);
	println("volume score: <determineRanking(rankingLoc)>");
	
	int rankingVol = rankingVolume(volumeResults);
	println("unit size score: <determineRanking(rankingVol)>");
	
	int rankingComp = rankingComplexity(CC);
	println("unit complexity score: <determineRanking(rankingComp)>");
	
	int rankingDupl = rankingDuplication(duplPercentage);
	println("duplication score: <determineRanking(rankingDupl)>");
	println("");
	
	// Maintainability Characteristics
	int analysability = getAnalysability(rankingVol, rankingDupl, rankingLoc);
	println("analysability score: <determineRanking(analysability)>" );
	
	int changability = getChangability(rankingComp, rankingDupl);
	println("changability score: <determineRanking(changability)>");
	
	int testability = getTestability(rankingComp, rankingLoc);
	println("testability score: <determineRanking(testability)>");
	println("");
	
	int maintainability = getMaintainability(analysability, changability, testability);
	println("overall maintainability score: <determineRanking(maintainability)>");
}