module MainVisualisation

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
import MethodVolume;
import MethodVolumeVisualisation;
import DuplicationVisualization;

bool COLORBLINDMODE = false;

map[str, int] complexityPerFile = readComplexityPerFile();
map[str,int] locPerFile = readLocPerFile();
 
 public void main()
{
	// Create Main menu
	mainMenu();	
}
	

public void mainMenu()
{
	//Figure btnMaintainability = button("Maintainability", mainPressed, buttonProperties() );
	//Figure btnVolume = button("Volume", volumePressed, buttonProperties());
	Figure btnMethodVol = button("Method Volume", volumeMethodPressed, buttonProperties());
	Figure btnDupl = button("Duplication", duplicationPressed, buttonProperties());
	Figure btnComplex = button("Complexity", complexityPressed, buttonProperties());
		
	render(vcat([btnMethodVol, btnDupl, btnComplex, btnColorBlind()], gap(20),  resizable(false)));	
}

public Figure btnColorBlind(){
   return vcat([ checkbox("ColorBlind Mode", void(bool s){ COLORBLINDMODE = s;})]);
}

list[FProperty] buttonProperties()
{
	return [fillColor("lightgrey"), size(150,20), resizable(false)];
}

public void mainPressed()
{
	
}

public void volumePressed()
{
}

public void setColorBlindMode(bool state)
{
	COLORBLINDMODE = state;
}


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

public Figure createGraphInfo() 
{
	return hcat([
			box(text("++"), fillColor(getColor(4)), size(25), resizable(false)),
			box(text("+"), fillColor(getColor(3)), size(25), resizable(false)),
			box(text("O"), fillColor(getColor(2)), size(25), resizable(false)),
			box(text("-"), fillColor(getColor(1)), size(25), resizable(false)),
			box(text("--"), fillColor(getColor(0)), size(25), resizable(false))
			]);
}

public Color getColor(int index)
{
	if(COLORBLINDMODE)
	{
		switch(index)
		{
			// Colors fetched from: 
			// https://www.edwardtufte.com/bboard/q-and-a-fetch-msg?msg_id=0000HT
			// https://colorbrewer2.org/#type=diverging&scheme=PuOr&n=5
			case 4: return rgb(44,123,182);
			case 3: return rgb(171,217,223);
			case 2: return rgb(255,255,191);
			case 1: return rgb(253,174,97);
			case 0: return rgb(215,25,28);
			default: return rgb(255,255,255);
		}
	}
	else
	{
		switch(index)
		{
			case 4: return color("Green");
			case 3: return color("Lightblue");
			case 2: return color("Yellow");
			case 1: return color("Orange");
			case 0: return color("Red");
			default: return color("White");
		}		
	}
}

public FProperty popup(str info)
{
	return mouseOver(box(text(info), fillColor("lightyellow"), grow(1.2), resizable(false)));
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

public Figure createInfo() 
{
	return hcat([
			box(text("Simple"), fillColor(getColor(4)), size(25), resizable(false)),
			box(text("More Complex"), fillColor(getColor(2)), size(25), resizable(false)),
			box(text("Complex"), fillColor(getColor(1)), size(25), resizable(false)),
			box(text("Untestable"), fillColor(getColor(0)), size(25), resizable(false))
			]);
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
