//	Storage.qml

pragma Singleton
import VPlay 2.0
import QtQuick 2.0

Item {
	id: item
	
	property int xpCurrent: -1
	property int xpLevelingConstant: -1	//	also the xp threshold for Level 1
	
	Storage {
		id: storage
		databaseName: "data"
		
		onStorageError: {
			console.warn("Fractureuns:/game/Storage.qml:Storage:storage ::: A storage error occured!");
			console.error(JSON.stringify(errorData));
		}
	}
	
	Component.onCompleted: {
		console.warn("Reloading JStorage...");
		
		var xpC = storage.getValue("xpCurrent");
		xpCurrent = xpC !== undefined ? xpC : 0;
		
		var xpLC = storage.getValue("xpLevelingConstant");
		xpLevelingConstant = xpLC !== undefined ? xpLC : 25;
		
	}
	
	onXpCurrentChanged: {
		storage.setValue("xpCurrent", xpCurrent);
	}
	
	onXpLevelingConstantChanged: {
		storage.setValue("xpLevelingConstant", xpLevelingConstant);
	}
	
	function addXp(amount) {
		if (amount === '' || isNaN(amount))
		{
			console.error("Fractureuns:/game/Storage.qml:addXp(amount) ::: Expected integer, got", "'" + amount + "'");
			return;
		}
		
		xpCurrent += amount;
	}
	
	function level(xp) {
		if (xp === '' || isNaN(xp))
			xp = xpCurrent;
		
		/*
		  XP Polynomial Equation:
		  
			y = I*x*(x + 1)/2
			
			where
				x = level,
				y = minimum xp required to reach level x,
				I = xp init/increment (xpLevelingConstant here)
		  */
		/*
		  Solving for x, by the quadratic equation, etc, we get
		  
		  x = -1/2 + √((I + 8y) / 4I)
		  x = -0.5 + √(0.25 + 2*y/I)
		  */
		
		return Math.floor(-0.5 + Math.sqrt(0.25 + 2 *xp / xpLevelingConstant));
	}
	
	function xpCurrentThresh() {
		return xpThresh(level());
	}
	
	function xpNextThresh() {
		return xpThresh(level() + 1);
	}
	
	function xpProgress() {
		var xpThreshAbove = xpNextThresh();
		var xpThreshBelow = xpCurrentThresh();
		return 1 - (xpThreshAbove - xpCurrent) / (xpThreshAbove - xpThreshBelow);
	}
	
	function xpThresh(lvl) {
		//	y = I*x*(x + 1)/2
		return (xpLevelingConstant * lvl * (lvl + 1) / 2);
	}
	
}
