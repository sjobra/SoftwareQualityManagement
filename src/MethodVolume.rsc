module MethodVolume

import IO;
import ValueIO;
import Set;
import List;
import util::Math;
import analysis::graphs::Graph;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;


import ProjectReader;
import FileHandler;

int low = 1;
int medium = 2;
int high = 3;
int complex = 4;

public list[str] filterComments(list[str] aMethod) {
// this regex filters out lines starting with slashes
	list[str] noDoc = [ a | a <- aMethod, /^[^\/\/]/ := a ];
	nodoc =  noDoc = [ a | a <- noDoc, /.*[^\s].*/ := a ];
	noDoc =  [ a | a <- noDoc, /.*[^\/\*].*/ := a ];
	noDoc =  [ a | a <- noDoc, /.*[^\*\/].*/ := a ];
	return noDoc;
}

//calculate volume
public map[str, real] cuv() {
	set[loc] allMethods = methods(myModel);
	real totalmethods = toReal(size(allMethods));
	
	map[loc, int] methodAmountOfLines = ();
	
	//println(totalmethods);
	//simple volume methods
	real svm = 0.0;
	//normal volume methods
	real nvm = 0.0;
	//normal volume methods
	real hvm = 0.0;
	//complex volume methods
	real cvm = 0.0;
	//println(readFileLines(allMethods[0]));
	for(met <- allMethods) {
		//println(readFileLines(met));
		list[str] aMethod = readFileLines(met);
		//println(size(filterComments(aMethod)));
		int lines = size(filterComments(aMethod));
		methodAmountOfLines += (met: lines);
		
		if(lines < 6) {
			svm = svm +1;
		} else if(lines > 5 && lines < 24) {
			nvm = nvm+1;
		} else if(lines > 23 && lines < 51) {
			hvm = hvm+1;
		} else {
			cvm = cvm+1;
		}
		//cvm = cvm + size(filterComments(aMethod));
		//hvm = hvm + size(aMethod);
		//break;
//		[10:41, 08/12/2020] Chu: Dan 6 t/'m 23 voor normale methodes
//[10:42, 08/12/2020] Chu: 24 t/m  50 voor complex
//[10:42, 08/12/2020] Chu: En 50+ voor zeer complex
	}
	
	//saveFileProperties(methodAmountOfLines);
	//println(svm); 
	map[str, real] volumeResults = ( "simple": 0.0, "moderate" : 0.0, "high": 0.0, "very high": 0.0);
	
	volumeResults["simple"] = (svm/totalmethods)*100;
	volumeResults["moderate"] = (nvm/totalmethods)*100;
	volumeResults["high"] = (hvm/totalmethods)*100;
	volumeResults["very high"] = (cvm/totalmethods)*100; 
	
	return volumeResults;
}


//calculate volume
public void cuvPerFile() {
	list[tuple[loc location, str filename, int complexity]] result = [];
	for(file <- javaFiles){
		M3 m3 = createM3FromEclipseFile(file);
		set[loc] fileMethods = methods(m3);
		int complexity = 0;
		for(method <- fileMethods){ 
			complexity += getComplexity(method);
			//print(method);
		}
		if(complexity > 0) {
			result += <file,  file.file, complexity>;
		}
	}
	result = sort(result, bool(tuple[loc location, str filename, int complexity] a, tuple[loc location, str filename, int complexity] b){ return a.complexity > b.complexity; });
	//sort(fruits, bool(str a, str b){ return size(a) > size(b); });
	saveMethodVolumePerFile(result);
}


public int getComplexity(loc method){
		list[str] aMethod = readFileLines(method);
		int lines = size(filterComments(aMethod));
		map[loc, int] methodAmountOfLines = (method: lines);
		if(lines < 6) {
			return low;
		} else if(lines > 5 && lines < 24) {
			return medium;
		} else if(lines > 23 && lines < 51) {
			return high;
		} else {
			return complex;
		}
}


public int rankingVolume(map[str, real] volumeResults)
{
	// m <=25 h = 0 vh = 0;
	if(volumeResults["moderate"] <= 25.0 && volumeResults["high"] == 0.0 && volumeResults["very high"] == 0.0)
		return 4;
	if(volumeResults["moderate"] <= 35.0 && volumeResults["high"] <= 5.0 && volumeResults["very high"] == 0.0)
		return 3;
	if(volumeResults["moderate"] <= 40.0 && volumeResults["high"] <= 10.0 && volumeResults["very high"] == 0.0)
		return 2;
	if(volumeResults["moderate"] <= 50.0 && volumeResults["high"] <= 15.0 && volumeResults["very high"] == 0.0)
		return 1;
	else
		return 0;	
}	



public void printVolume(map[str, real] volumeResults)
{
	//volumeResults["simple"] = floor((svm/totalmethods)*100);
	//volumeResults["moderate"] = floor((nvm/totalmethods)*100);
	//volumeResults["high"] = floor((hvm/totalmethods)*100);
	//volumeResults["very high"] = floor((cvm/totalmethods)*100); 
							
	println(" * simple: <floor(volumeResults["simple"])> %");
	println(" * moderate: <floor(volumeResults["moderate"])> %");
	println(" * high: <floor(volumeResults["high"])> %");
	println(" * very high: <floor(volumeResults["very high"])> %");
}
public real getTotalAmountOfMethods()
{
	//set[loc] allMethods = methods(myModel);
	return toReal(size(allJavaMethods));
	
}