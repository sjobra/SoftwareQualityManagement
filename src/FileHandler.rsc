module FileHandler

import IO;
import Set;
import ValueIO;

loc filesAndMethodsAndLOC = |file:///C:/tmp/MethodsVsLinesOfCode.txt|;
loc complexity= |file:///C:/Complexity.txt|;
loc maintainability = |file:///C:/maintainability.txt|;


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

//public void leesEnToon() {
//   Graph[str] g = readTextValueFile(#Graph[str], tmp);
//  println("ingelezen: <g>");
//   println("grootte: <size(g)>");
//}