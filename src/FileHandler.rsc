module FileHandler

import IO;
import ValueIO;

loc filesAndMethodsAndLOC = |file:///C:/tmp/MethodsVsLinesOfCode.txt|;
loc cyclComplexity= |file:///C:/tmp/CComplexity.txt|;
loc locPerFile= |file:///C:/tmp/locPerFile.txt|;
loc maintainability = |file:///C:tmp/maintainability.txt|;


public map[loc, int] readFileProperties() 
{
	return readTextValueFile(#map[loc, int], filesAndMethodsAndLOC);
}

public list[tuple[loc, str, str, int, int]] readComplexity() 
{
	return readTextValueFile(#list[tuple[loc, str, str, int, int]], cyclComplexity);
}

public void saveCC(list[tuple[loc, str, str, int, int]] cyclComplex)
{
	writeTextValueFile(cyclComplexity, cyclComplex);
}

public void saveLoc(map[loc, int] linesOfCode)
{
	writeTextValueFile(filesAndMethodsAndLOC, linesOfCode);
}

public list[tuple[str,int]] readLocPerFile()
{
	return readTextValueFile(#list[tuple[str,int]], locPerFile);
}

public void saveLocPerFile(list[tuple[str,int]] locPerJavaFile)
{
	writeTextValueFile(locPerFile, locPerJavaFile);
}



