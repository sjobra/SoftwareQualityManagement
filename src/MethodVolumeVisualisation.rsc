module MethodVolumeVisualisation

import analysis::graphs::Graph;
import Relation;
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
import IO;

import ValueIO;
import Set;
import List;
import analysis::graphs::Graph;


import FileHandler;
import MethodVolume;
import MainVisualisation;


public void volumeMethodPressed() {
	list[tuple[loc location, str name, int methodCount, int highestComplexity]] methodvolume = readMethodVolumePerFile();
	
	list[Figure] boxes = [];
	
	int incr = 0;
	
	for(file <- methodvolume) {
		str filename = replaceAll(file.name, ".java","");
		//this part adds a box to the treegrid. It shows the number of methods, the color is displayed depending on the highest complexity within that class.
		//it shows the file name as popup and when clicked it will go to that class so one can see an overview of it's methods and the complexity therein.
		boxes += box(text(toString(file.methodCount)),area(file.methodCount), fillColor(getColor(file.highestComplexity)), popup(file.name), clickMethodVolumeFile(file.location, file.name));	
		incr = incr + 1;
	}
	t = treemap(boxes);
	image = box(vcat([text("Volume"), createInfo(), t], vgrow(1.1)));
	render(image);
}

public FProperty clickMethodVolumeFile(loc location, str filename) {
//public FProperty click(loc loca, str filename) {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		if(butnr == 1) {
			volumeMethodFile(location, filename);
		} else if(butnr == 3) {
			mainMenu();
		}
    	return true;	
    });
}


public FProperty popup(str S){
 return mouseOver(box(text(S), fillColor("lightyellow"),
 grow(1.2),resizable(false)));
}

public void volumeMethodFile(loc location, str name) {
	M3 m3 = createM3FromEclipseFile(location);
	set[loc] fileMethods = methods(m3);
	
	list[Figure] boxes = [];
	boxes += box(text(name),area(10), fillColor("white"));	
	
	for(met <- fileMethods){ 
			int complexity = getComplexity(met);
			ccolor = 0;
			if(complexity == 1) {
				ccolor = 4;
			} else if(complexity == 2) {
				ccolor = 2;
			} else if(complexity == 3) {
				ccolor = 1;
			}
			boxes += box(text(met.file),area(10), fillColor(getColor(ccolor)), clickMethodVolumeMethod(location, met, name));
		}
	render(vcat((boxes), vgrow(1.1)));
}


public FProperty clickMethodVolumeMethod(loc file, loc location, str name) {
//public FProperty click(loc loca, str filename) {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		if(butnr == 1) {
			list[str] aMethod = readFileLines(location);
			str aline = "";
			incr = 1;
			for(line <- aMethod){
				aline = aline + toString(incr) + "  " +  line + "\n";
				incr = incr + 1;
			}
			Figure toRender = box(text(aline), align(0, 0), area(100), fillColor("white"),clickMethodVolumeMethodReturn(file, name));
			
			render(toRender);
		} else if(butnr == 3) {
			volumeMethodPressed();
		}
    	return true;	
    });
}

public FProperty clickMethodVolumeMethodReturn(loc file, str filename) {
//public FProperty click(loc loca, str filename) {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		if(butnr == 3) {
			//volumeMethodPressed();
			volumeMethodFile(file, filename);
		}
    	return true;	
    });
}


