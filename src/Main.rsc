module Main

import IO;

import ProjectReader;
import LinesOfCode;
import MethodVolume;
import Duplication;
import CyclomaticComplexity;
import Utilities;

public void main()
{
	println("Project: smallSQL");
	println("----");	
	int linesOfCode = getLinesOfCodeProgram();
	println("lines of code : <linesOfCode>"  );
	println("number of units: <getTotalAmountOfMethods()>");
	println("unit size");
	cuv();
	println("unit complexity");
	calculateCyclomaticComplexity();
	printEvalCC();
	println("duplication:");
	// Quick version without Calculation
	as();
	
	
	// Slow version with calculation
	// println(<duplication()>);
	int duplPercentage = getPercentage();
	//duplication();
	
	int rankingLoc = rankingLOC(linesOfCode);
	determineRanking(rankingLoc);
	rankingLOC(linesOfCode);
	
	println("unit size score: +");
	determineComplexity();
	
	int rankingDupl = rankingDuplication(duplPercentage);
	determineRanking(rankingDupl);
	
	println("");
	println("analysability score: +");
	println("changability score: -");
	println("testability score: ++");
	println("");
	println("overall maintainability score: ++");
}