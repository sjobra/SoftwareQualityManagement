module FileHandler

import IO;
import Set;
import ValueIO;

loc filesAndMethodsAndLOC = |file:///C:/tmp/MethodsVsLinesOfCode.txt|;
loc complexity = |file:///C:/tmp/Complexity.txt|;
loc maintainability = |file:///C:tmp/maintainability.txt|;
loc methodVolumePerFile = |file:///C:/tmp/MethodVolume.txt|;
loc methodVolumePerMethod = |file:///C:/tmp/MethodVolume.txt|;
loc duplication = |file:///C:/tmp/Duplication.txt|;



//Graph[str] gebruikt = {<"A", "B">, <"A", "D">, 
//   <"B", "D">, <"B", "E">, <"C", "B">, <"C", "E">, 
//   <"C", "F">, <"E", "D">, <"E", "F">};
   
public void saveFileProperties(map[loc, int] fileProperties) 
{
   writeTextValueFile(filesAndMethodsAndLOC, fileProperties);
}

public map[loc, int] readFileProperties() 
{
	return readTextValueFile(#map[loc, int], filesAndMethodsAndLOC);
}

public void saveComplexity(list[tuple[loc, str, int, int]] cyclComp)
{
	writeTextValueFile(complexity, cyclComp);
}

public list[tuple[loc, str, int, int]] readComplexity() 
{
	return readTextValueFile(#list[tuple[loc, str, int, int]], complexity);
}

public void saveMethodVolumePerFile(list[tuple[loc, str, int]] mv)
{
	writeTextValueFile(methodVolumePerFile, mv);
}

public list[tuple[loc, str, int]] readMethodVolumePerFile() 
{
	return readTextValueFile(#list[tuple[loc, str, int]], methodVolumePerFile);
}

public void saveMethodVolumePerMethod(list[tuple[loc, str, str, int]] mv)
{
	writeTextValueFile(methodVolumePerMethod, mv);
}

public list[tuple[loc, str, int, int]] readMethodVolumePerMethod() 
{
	return readTextValueFile(#list[tuple[loc, str, int, int]], methodVolumePerMethod);
}

//public void leesEnToon() {
//   Graph[str] g = readTextValueFile(#Graph[str], tmp);
//  println("ingelezen: <g>");
//   println("grootte: <size(g)>");
//}