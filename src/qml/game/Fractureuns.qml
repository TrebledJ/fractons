pragma Singleton
import VPlay 2.0
import QtQuick 2.0

import "../game"

Item {
//	id: item
	
	signal levelUp(int level)
	
	property int fCurrent: -1
	property int fLevelingConstant: -1	//	also the fractureuns threshold for Level 1
	
	Component.onCompleted: {
		//	basic setup and data retrieval
		console.warn("Reloading JFractureuns...");
		
		var fC = JStorage.getValue("fCurrent");
		fCurrent = fC !== undefined ? fC : 0;
		
		var fLC = JStorage.getValue("fLevelingConstant");
		fLevelingConstant = fLC !== undefined ? fLC : 25;
	}
	
	onFCurrentChanged: {
		setFractureuns(fCurrent);
	}
	
	onFLevelingConstantChanged: {
		//	should need this
		//	JStorage.setValue("fLevelingConstant", fLevelingConstant);
	}
	
	onLevelUp: {
		console.warn("Player leveled up!");
	}
	
	function addFractureuns(amount) {
		if (amount === '' || isNaN(amount))
		{
			console.error("Fractureuns:/game/Storage.qml:addFractureuns(amount) ::: Expected integer, got", "'" + amount + "'");
			return;
		}
		
		fCurrent += amount;	//	add amount
		
		if (level(fCurrent - amount) < level(fCurrent))	//	check if difference caused level-up
			levelUp(level(fCurrent));
	}
	
	function level(fractureuns) {
		if (fractureuns === '' || isNaN(fractureuns))
			fractureuns = fCurrent;
		
		/*
		  XP Polynomial Equation:
		  
			y = I*x*(x + 1)/2
			
			where
				x = level,
				y = minimum fractureuns required to reach level x,
				I = fractureuns init/increment (fractureunsLevelingConstant here)
		  */
		/*
		  Solving for x, by the quadratic equation, etc, we get
		  
		  x = -1/2 + √((I + 8y) / 4I)
		  x = -0.5 + √(0.25 + 2*y/I)
		  */
		
		return Math.floor(-0.5 + Math.sqrt(0.25 + 2 *fractureuns / fLevelingConstant)) + 1;
	}
	
	function fCurrentThresh() {
		return fThresh(level());
	}
	
	function fNextThresh() {
		return fThresh(level() + 1);
	}
	
	function fProgress() {
		var fThreshAbove = fNextThresh();
		var fThreshBelow = fCurrentThresh();
		return 1 - (fThreshAbove - fCurrent) / (fThreshAbove - fThreshBelow);
	}
	
	function fThresh(lvl) {
		//	y = I*x*(x + 1)/2
		return (fLevelingConstant * (lvl - 1) * lvl / 2);
	}
	
	
	//	centralised function, don't need to bother with remembering the key (i.e. fCurrent)
	function setFractureuns(ftn) {
		JStorage.setValue("fCurrent", ftn);
	}
	
}
