module Duplication

import IO;
import String;
import Set;
import List;
import util::Math;
import analysis::graphs::Graph;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;
import vis::Figure;

import FileHandler;
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
	return 5;
}

//public int duplication() {
//	set[loc] allMethods = methods(model);
//	list[str] filteredmethods = [];
//	//allMethods = (x: allMethods[x]  | x <- allMethods,  readFileLines(allMethods[x]) > 4 );
//	
//	//all methods with less then 4 lines are removed here.
//	for(met <- allMethods) {
//		list[str] aMethod = readFileLines(met);
//		
//		int lines = size(filterComments(aMethod));
//		if(lines > 4){
//			filteredmethods = filteredmethods + filterComments(aMethod);
//		}
//	}
//	int originalSize = size(filteredmethods);
////	println(size(filteredmethods));
//	
//	int daSize = size(filteredmethods);
//
//	int parsed = 0;
//	list[str] investigated = take(5, filteredmethods);
//	filteredmethods = drop(5, filteredmethods);
//	daSize = daSize - 5;
//	int iteration = 0;
//	int duplicatecode = 0;
//	while (parsed < daSize) {
//		//println(size(filteredmethods));
//		int i = 0;
//		while(i <= daSize) {
//			//this method gets the top value to slice of which is +5 atm.
//			int top = getTop(i, daSize);
//			//println(toString(i) + " " + toString(top) + " " + toString(size(filteredmethods)));
//			//println
//			list[str] toDetect = slice(filteredmethods, i, top);
//			//println("hit");
//			if(toDetect == investigated) {
//				int increment = 0;
//				list[str] duplicateOriginal = investigated;
//				
//				while(toDetect == duplicateOriginal){
//					duplicateOriginal = investigated + filteredmethods[increment];
//					toDetect = slice(filteredmethods, i, top + increment + 1);
//					increment = increment + 1;
//				}
//				// need to remove this, if the while loop ends it means we need to increment one back
//				toDetect = slice(filteredmethods, i, top + increment);
//				// need to remove duplicate code
//				int detectedDuplicate = size(toDetect);
//				duplicatecode = duplicatecode + detectedDuplicate;
//				
//				//println(size(filteredmethods));
//				//println(daSize);
//				
//				//just removing the list from filteredmethods will remove all occurances. Only need to remove current occurance
//				list[str] bottomPart = slice(filteredmethods, 0, i);				
//				//println("total size: " + toString(size(filteredmethods)) + " bottomsize: " + toString(size(bottomPart)) + " duplicated lines: " + toString(detectedDuplicate));
//				//println("toppart: " + toString(size(filteredmethods) - (size(bottomPart) + detectedDuplicate)));
//				
//				
//				list [str] topPart = slice(filteredmethods, i + detectedDuplicate, daSize - (size(bottomPart) + detectedDuplicate));
//				filteredmethods = bottomPart + topPart;
//				daSize = daSize - detectedDuplicate;
//				//just removing the list from filteredmethods will remove all occurances. Only need to remove current occurance
//				//filteredmethods = filteredmethods - toDetect;
//				//println(daSize);
//			} else {
//				i =i+1;
//			}
//		}
//		// eentje erbij doen en een eraf halen
//		iteration = iteration+1;
//		investigated = investigated + take(1, filteredmethods);
//		investigated = drop(1, investigated);
//		//wat we hebben gehad hoeven we niet te parsen
//		filteredmethods = drop(1, filteredmethods);
//		daSize = daSize - 1;
//	}
//
//	
//	
//	real fracture = toReal(duplicatecode)/toReal(originalSize);
//	return toInt(fracture*100);
//}

public void duplication2() {
	list[loc] allMethods = toList(methods(model));
	list[set[loc]] result = [];

	int increment = 0;
	for(met <- allMethods) {
		int increment = 0;
		list[str] aMethod = readFileLines(met);
		aMethod = filterComments(aMethod);
		int lines = size(aMethod);
		//file method needs to be 5 or more lines.
		set[loc] duplicateLocations = {}; 
		//all
		allMethods = drop(1,allMethods);
		//allMethods = allMethods & {met};
		if(lines > 4){
			int methodLineIncrement = 0;
			while(size(aMethod) > methodLineIncrement+5) {
				list[str] investigator = slice(aMethod, methodLineIncrement, 5);	
				for(metInner <- allMethods){				
					list[str] blinesTotal = readFileLines(metInner);
					int innerMethodLineIncr = 0;
					if(size(blinesTotal) > 4) {
						int found = 0;
						while(size(blinesTotal) > innerMethodLineIncr+5 && found == 0){
							list[str] blines = slice(blinesTotal, innerMethodLineIncr, 5);
							if(blines == investigator){
									println("hit");
									println(met);
									println(metInner);
						//		//
									duplicateLocations += met;
									duplicateLocations += metInner;
									allMethods = delete(allMethods, increment);
						//			found=1;
									innerMethodLineIncr = innerMethodLineIncr+1;
									break;
							}
							innerMethodLineIncr = innerMethodLineIncr+1;
						}

					} //else {
						//allMethods = allMethods & {metInner};
					//}
				}
				methodLineIncrement = methodLineIncrement +1;
				increment = increment+1;	
				//println(increment);
			}
		} 
		if(size(duplicateLocations)>0){
			result+=duplicateLocations;
		}		

		
	}
	
	saveDuplication(result);
}


public void as(){
	println("duplication: " + toString(toInt(0.08773170362*100)) + "%");

}

public int rankingDuplication(int percentage) {
	if(percentage <= 3)
		return 4;
	elseif(percentage > 3 && percentage <= 5)
		return 3;
	elseif(percentage > 5 && percentage <= 10)
		return 2;
	elseif(percentage > 10 && percentage <= 20)
		return 1;
	else return 0;
}

public int getPercentage()
{
	return toInt(0.08773170362*100);
}


