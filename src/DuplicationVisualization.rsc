module DuplicationVisualization

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
import CyclomaticComplexity;
import MethodVolume;
import MainVisualisation;


public void duplicationPressed() {
	list[set[loc]] duplicationSets = readDuplication();
	
	list[Figure] boxes = [];
	
	int group = 0;
	for(aSet <- duplicationSets){
		list[Figure] duplicates = [];
		for(aLocation <- aSet){
			duplicates += box(text(toString(group)), area(size(aSet)), popup(aLocation.path), getColor(size(aSet)), clickDuplicationMethod(aLocation));//, area(10), fillColor("White"));	
		}
		group = group +1;
		boxes += duplicates;//box(duplicates, fillColor("Black"));
	}
	t = treemap(boxes);
	image = box(vcat([text("Duplication"), t], vgrow(1.1)));
	render(image);
}


public FProperty getColor(int amount){ 
	FProperty color = fillColor("red");
	if(amount < 3) {
		color = fillColor("green");
	} else if(amount == 3 || amount == 4) {
		color = fillColor("DarkGreen");
	} else if(amount > 4 && amount < 8) {
		color = fillColor("Crimson");
	}
	return color;
}

public FProperty popup(str S){
 return mouseOver(box(text(S), fillColor("lightyellow"),
 grow(1.2),resizable(false)));
}

public FProperty clickDuplicationMethod(loc file) {
//public FProperty click(loc loca, str filename) {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		if(butnr == 1) {
			list[str] aMethod = readFileLines(file);
			str aline = "";
			incr = 1;
			for(line <- aMethod){
				aline = aline + toString(incr) + "  " +  line + "\n";
				incr = incr + 1;
			}
			Figure toRender = box(text(aline), align(0, 0), area(100), fillColor("white"), clickDuplicationOverviewReturn());
			
			render(toRender);
		} else if(butnr == 3) {
			mainMenu();
		}
    	return true;	
    });
}

public FProperty clickDuplicationOverviewReturn() {
//public FProperty click(loc loca, str filename) {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		if(butnr == 3) {
			//volumeMethodPressed();
			duplicationPressed();
		}
    	return true;	
    });
}


