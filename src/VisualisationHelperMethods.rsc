module VisualisationHelperMethods

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
import util::Editors;
import IO;

import ValueIO;
import Set;
import List;
import analysis::graphs::Graph;


import FileHandler;
import CyclomaticComplexity;
import MethodVolume;
import VisualisationHelperMethods;
import MainVisualisation;


public void volumeMethodPressed() {
	list[tuple[loc location, str name, int complexity]] methodvolume = readMethodVolumePerFile();
	
	list[Figure] boxes = [];
	
	int incr = 0;
	
	for(file <- methodvolume) {
		str filename = replaceAll(file.name, ".java","");
		boxes += box(text(toString(file.complexity)),area(file.complexity),fillColor("white"), popup(file.name), clickMethodVolumeFile(file.location, file.name));	
		incr = incr + 1;
	}
	t = treemap(boxes);
	render(t);
}

public FProperty clickMethodVolumeFile(loc location, str filename) {
//public FProperty click(loc loca, str filename) {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		if(butnr == 1) {
			volumeMethodFile(location, filename);
		} else if(butnr == 3) {
			main();
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
			FProperty color = fillColor("red");
			if(complexity == 1) {
				color = fillColor("green");
			} else if(complexity == 2) {
				color = fillColor("DarkGreen");
			} else if(complexity == 3) {
				color = fillColor("Crimson");
			}
			boxes += box(text(met.file),area(10), color, clickMethodVolumeMethod(location, met, name));
		}
	
	render(vcat(boxes));
}


public FProperty clickMethodVolumeMethod(loc file, loc location, str name) {
//public FProperty click(loc loca, str filename) {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		if(butnr == 1) {
			list[str] aMethod = readFileLines(location);
			list[Figure] lines = [];
			str aline = "";
			for(line <- aMethod){
				aline = aline + line + "\n";
				lines += text(line, halign(0.0));
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


