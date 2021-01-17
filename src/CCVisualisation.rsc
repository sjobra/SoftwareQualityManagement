module CCVisualisation

import analysis::graphs::Graph;
import lang::java::jdt::m3::Core;
import String;
import vis::Figure;
import vis::Render;
import vis::KeySym;

import List;
import Map;
import IO;
import util::Math;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;
import Set;

import ProjectReader;
import FileHandler;
import CyclomaticComplexity;
import MainVisualisation;

map[str, int] complexityPerFile = readComplexityPerFile();
map[str,int] locPerFile = readLocPerFile();

public void complexityPressed()
{	
	list[Figure] boxlist = [];
	for(<filename, linesOfCode> <- toList(locPerFile))
	{
		newFile = filename;
		boxlist += box( id(filename), area(linesOfCode), fillColor(getColor(complexityPerFile[filename])), popup(filename), handleMouseEvent(newFile));
	}
	boxes = treemap(boxlist);
	
	image = box(vcat([text("Complexity"), createGraphInfo(), boxes], vgrow(1.1)));
	render(image);	
}

public FProperty handleMouseEvent(str filename)
{
	return onMouseDown(bool(int butnr,map[KeyModifier, bool] modifiers)
	{
		if (butnr == 3)
		{
			mainMenu();
		}
		else
		{
			renderFile(filename);
		}
		return true;
	});
}

public void renderFile(str fileName)
{
	// Load all complexity...
	list[tuple[loc place, str file, str met, int cc, int linesOfCode]] complexity = readComplexity();
	list[tuple[str file, str met, int cc, int linesOfCode]] filteredComplexity = [];
	 
	for (complItem <- complexity)
	{
		if(complItem.file == fileName)
		{
		 	filteredComplexity += < complItem.file, complItem.met, complItem.cc, complItem.linesOfCode >;
		}
	}
	
	boxes = treemap([box( id(met), area(linesOfCode), fillColor(getColor(RankCC(cc))), popup(met), handleMouseEventComplexity()) |
	<filename, met, cc, linesOfCode> <- filteredComplexity]);
	image = box(vcat([text(fileName), createInfo(), boxes], vgrow(1.1)));
	render(image);
}

public int RankCC(int cc)
{
	if (cc <= 10)
		return 4;
	if (cc<=20)
		return 2;
	if (cc<=50)
		return 1;
	else return 0;		
}
public FProperty handleMouseEventComplexity()
{
	return onMouseDown(bool(int butnr,map[KeyModifier, bool] modifiers)
	{
		if (butnr == 3)
		{
			complexityPressed();
		}
		return true;
	});
}