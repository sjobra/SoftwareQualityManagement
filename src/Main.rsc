module Main

import IO;
import util::Resources;
import Set;
import Map;
import List;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import Relation;

import ProjectReader;
import CyclomaticComplexity;

public void main()
{
	println("Project: smallSQL");
							
	CC = calculateCyclomaticComplexity();
	
	for( cyclo <- CC)
	{
		println(cyclo);
	}
	
}