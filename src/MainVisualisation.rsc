module MainVisualisation

import analysis::graphs::Graph;
import lang::java::jdt::m3::Core;
import Relation;
import vis::Figure;
import vis::Render;
import vis::KeySym;
import Map;
import List;
import Set;

import ProjectReader;
import FileHandler;
import CyclomaticComplexity;

bool COLORBLINDMODE = false;
 
 public void main()
{
	// Create Main menu
	mainMenu();	
}
	


public void mainMenu()
{
	Figure btnMaintainability = button("Maintainability", mainPressed, fillColor("grey"), size(150,20), resizable(false) );
	Figure btnVolume = button("Volume", volumePressed, fillColor("grey"), size(150,20), resizable(false));
	Figure btnMethodVol = button("Method Volume", volumeMethodPressed, fillColor("grey"), size(150,20), resizable(false));
	Figure btnDupl = button("Duplication", duplicationPressed, fillColor("grey"), size(150,20), resizable(false));
	Figure btnComplex = button("Complexity", complexityPressed, fillColor("grey"), size(150,20), resizable(false));
	Figure btnColorBlind = checkbox("ColorBlind Mode", void(bool s){COLORBLINDMODE = s;});
	
	render(vcat([btnMaintainability, btnVolume, btnMethodVol, btnDupl, btnComplex, btnColorBlind], gap(20),  resizable(false)));	
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
	complexityPerFile = readComplexityPerFile();
	map[str,int] locPerFile = readLocPerFile();
	
	boxes = treemap([box( id(filename), area(linesOfCode), fillColor(getColor(complexityPerFile[filename])), popup(filename), handleMouseEvent(filename))|
	<filename, linesOfCode> <- toList(locPerFile)]);
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


public void volumeMethodPressed()
{
}

public void duplicationPressed()
{
}

private Figure createGraphInfo() 
{
	return hcat([box(text("++"),fillColor("Green"), size(25), resizable(false)),
			box(text("+"), fillColor("Lightblue"), size(25), resizable(false)),
			box(text("O"),fillColor("Yellow"), size(25), resizable(false)),
			box(text("-"),fillColor("Orange"), size(25), resizable(false)),
			box(text("--"),fillColor("Red"), size(25), resizable(false))]);
}

private Color getColor(int index)
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
	
	boxes = treemap([box( id(met), area(linesOfCode), fillColor(getColor(cc)), popup(met)) |
	<filename, met, cc, linesOfCode> <- filteredComplexity]);
	render(boxes);	
}