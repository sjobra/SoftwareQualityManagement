module Duplication

import IO;
import Relation;
import Map;
import Set;
import List;
import util::Math;
import analysis::graphs::Graph;
import util::Resources;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;
import vis::Figure;
import vis::Render;
import vis::KeySym;


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
		return daSize-i;
	}
	return i;
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

	//println(size(filteredmethods));
	
	int parsed = 0;
	list[str] toDetect = [];
	while (parsed < daSize) {
		toDetect = take(5, filteredmethods);
		filteredmethods = drop(5, filteredmethods);
		daSize = daSize - 5;
		
		println(size(filteredmethods));
		int i = 0;
		while(i <= daSize) {
			int top = getTop(i, daSize);
			list[str] investigated = slice(filteredmethods, i, i + 5);
			break;
			//if(toDetect)	
		}
		break;
	}

}