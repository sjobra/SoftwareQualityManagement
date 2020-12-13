module Duplication

import IO;
import Set;
import List;
import util::Math;
import analysis::graphs::Graph;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;
import vis::Figure;

public M3 model = createM3FromEclipseProject(|project://smallsql/|);

public list[str] filterComments(list[str] aMethod) {
// this regex filters out lines starting with slashes
	list[str] noDoc = [ a | a <- aMethod, /^[^\/\/]/ := a ];
	nodoc =  noDoc = [ a | a <- noDoc, /.*[^\s].*/ := a ];
	noDoc =  [ a | a <- noDoc, /.*[^\/\*].*/ := a ];
	noDoc =  [ a | a <- noDoc, /.*[^\*\/].*/ := a ];
	return noDoc;
}

public int getTop(int i, int daSize){
	if(i+5> daSize) {
		return daSize-i-1;
	}
	return i+5;
}

public void duplication() {
	set[loc] allMethods = methods(model);
	list[str] filteredmethods = [];
	//allMethods = (x: allMethods[x]  | x <- allMethods,  readFileLines(allMethods[x]) > 4 );
	
	for(met <- allMethods) {
		list[str] aMethod = readFileLines(met);
		
		int lines = size(filterComments(aMethod));
		if(lines > 4){
			filteredmethods = filteredmethods + filterComments(aMethod);
		}
	}
	println(size(filteredmethods));
	
	int daSize = size(filteredmethods);

	int parsed = 0;
	list[str] investigated = take(5, filteredmethods);
	filteredmethods = drop(5, filteredmethods);
	daSize = daSize - 5;
	while (parsed < daSize) {
		println(size(filteredmethods));
		int i = 0;
		while(i <= daSize) {
			//this method gets the top value to slice of which is +5 atm.
			int top = getTop(i, daSize);
			println(toString(i) + " " + toString(top) + " " + toString(size(filteredmethods)));
			//println
			list[str] toDetect = slice(filteredmethods, i, top);
			//println("hit");
			if(toDetect == investigated) {
			int d = 5;
				//TODO: increment both with one
				//break;
				println("hit");
				println(toDetect);
				println(investigated);
				break;
			} else {
				i =i+1;
			}
	
			//if(toDetect)	
		}
		// eentje erbij doen en een eraf halen
		investigated = investigated + take(1, filteredmethods);
		investigated = drop(1, investigated);
		//wat we hebben gehad hoeven we niet te parsen
		filteredmethods = drop(1, filteredmethods);
		daSize = daSize - 1;
		break;
	}

}