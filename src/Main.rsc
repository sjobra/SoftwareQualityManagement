module Main

import IO;

import ProjectReader;
import LinesOfCode;
import MethodVolume;
import Duplication;

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
	println("simple");
	println("moderate");
	println("high");
	println("very high");
	println("duplication:");
	as();
	
	int duplPercentage = getPercentage();
	//duplication();
	rankingLOC(linesOfCode);
	println("unit size score: +");
	println("unit complexity score: +/-");
	rankingDuplication(duplPercentage);
	println("");
	println("analysability score: +");
	println("changability score: -");
	println("testability score: ++");
	println("");
	println("overall maintainability score: ++");
}