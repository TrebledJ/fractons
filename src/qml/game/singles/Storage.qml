//	Storage.qml

pragma Singleton
import Felgo 3.0
import QtQuick 2.0

/**
  
  
  Sources and Citations
  [1]: Qt.platform: http://doc.qt.io/qt-5/qml-qtqml-qt.html#platform-prop
  
	`Qt.platform.os` available enums: 
	 + android
	 + ios
	 + tvos
	 + linux
	 + osx
	 + qnx
	 + unix
	 + windows
	 + winrt
	 
	 Mobile versions will include
	  * android
	  * ios
	  * tvos
	  * winrt

*/

import "../../js/Utils.js" as JUtils

Item {
	id: item
	
	readonly property bool isMobile: "android,ios,tvos,winrt".includes(Qt.platform.os);
	
//	readonly property var defaultKeys: ({	//	object with key-value pairs of default values
//											fCurrent: 0,
//											fLevelingConstant: 25,
//											combo: 0,
											
//											achievements: {
//												explorer: {
//													associate: {
//														name: 'Associate',
//														description: 'Correctly answer a question.',
//														hint: '',
//														group: 'explorer',
//														reward: 1,
//														progress: 0,
//														maxProgress: 1,
//														isCollected: false
//													},
//												},
//												studious: {
													
//												},
//												sprinter: {
//													1: {
//														name: 'Sprinter I',
//														description: 'Reach a combo of 3.',
//														hint: '',
//														group: 'sprinter',
//														reward: 10,
//														progress: 0,
//														maxProgress: 3,
//														isCollected: false
//													},
//													2: {
//														name: 'Sprinter II',
//														description: 'Reach a combo of 10.',
//														hint: '',
//														group: 'sprinter',
//														reward: 30,
//														progress: 0,
//														maxProgress: 10,
//														isCollected: false
//													},
//													3: {
//														name: 'Sprinter III',
//														description: 'Reach a combo of 30.',
//														hint: '',
//														group: 'sprinter',
//														reward: 60,
//														progress: 0,
//														maxProgress: 30,
//														isCollected: false
//													},
//													4: {
//														name: 'Sprinter IV',
//														description: 'Reach a combo of 60.',
//														hint: '',
//														group: 'sprinter',
//														reward: 120,
//														progress: 0,
//														maxProgress: 60,
//														isCollected: false
//													},
//													5: {
//														name: 'Sprinter V',
//														description: 'Reach a combo of 120.',
//														hint: '',
//														group: 'sprinter',
//														reward: 250,
//														progress: 0,
//														maxProgress: 120,
//														isCollected: false
//													}
//												},
//												mastery_general: {
													
//												},
//												leveller: {
													
//												},
//												warrior: {
													
//												},
//												mastery: {
//													balance: {
														
//													},
//													conversion: {
														
//													},
//													truth: {
														
//													},
//													operations: {
														
//													},
//												},
//												secret: {
//													nou: {
//														name: 'no u',
//														description: 'Input "no u".',
//														hint: 'no u',
//														group: 'secret',
//														reward: 500,
//														progress: 0,
//														maxProgress: 5,
//														isCollected: false
//													},
//												},
//												classified: {
													
//												},
//											},
											
////											stats_general: {
////												'2019-02-26': {
////													attempted: 0,
////													correct: 0,
////													fractonsEarned: 0
////												},
////											},
////											stats_questions: [
////												{
////													mode: 'Balance',
////													difficulty: '',
////													question: '2/4 = ?/2',
////													input: '1',
////													answer: '1',
////													isCorrect: true,
////												},
////											],
//											stats_general: {
												
//											},
//											stats_questions: [
												
//											],
											
//										})
	
	property alias storage: storage
	
	Storage {
		id: storage
		databaseName: "data"
		
//		clearAllAtStartup: true	//	uncomment to clear db at startup
		
		onStorageError: {
			console.warn("Fractons:/game/singles/Storage.qml:Storage:storage ::: A storage error occured!");
			console.error(errorData.message);
		}
		
		function fillDefaults() {
			var json = fileUtils.readFile(Qt.resolvedUrl("defaultkeys.json"));
			var defaultKeys = JSON.parse(json);
			fillMissingMasteryAchievements(defaultKeys);
//			for (var key in defaultKeys)
//			{
//				setValue(key, defaultKeys[key]);
//			}
			
			//	checking keys
			console.log("Checking keys...");
			for (var key in defaultKeys)
			{
				var res = getValue(key);
				if (res === undefined)
				{
					console.log("Key", key, "is undefined... Fixing...");
					setValue(key, defaultKeys[key]);
				}
			}
		}
		
		function fillMissingMasteryAchievements(keys) {
			for (var k in keys.achievements.mastery)
			{
				for (var i = 1; i <= 5; i++)
				{
					var obj = {
						name: JUtils.toTitleCase(k) + " " + ["I", "II", "III", "IV", "V"][i - 1],
						description: "Obtain a level " + i + " mastery in " + JUtils.toTitleCase(k) + " mode.",
						hint: '',
						group: k,
						reward: [10, 30, 60, 120, 250][i - 1],
						progress: 0,
						maxProgress: i,
						isCollected: false
					};
					
					keys.achievements.mastery[k][i] = obj;
				}
			}
		}
	}
	
	Component.onCompleted: {
		console.warn("Reloading JStorage...");
		
		//	see [1]
		console.warn("Current platform:", Qt.platform.os);
		
//		var json = fileUtils.readFile(Qt.resolvedUrl("defaultkeys.json"));
//		console.log("Read JSON:", json);
		
//		var defaultKeys = JSON.parse(json);
//		console.log("Parsed JSON:", JSON.stringify(defKeys));
		
//		storage.fillMissingMasteryAchievements(defaultKeys);
		
		storage.fillDefaults();
		
	}
	
	function getValue(key) {
		return storage.getValue(key);
	}
	
	function setValue(key, value) {
		storage.setValue(key, value);
	}
	
	
	function combo() {
		return getValue("combo");
	}
	
	function addCombo(amount) {
		if (amount === "" || isNaN(amount))
			return;
		
		setValue("combo", combo() + amount);
	}
	
	function setCombo(amount) {
		if (amount === "" || isNaN(amount))
			return;
		
		setValue("combo", amount);
	}
	
	function tokens() {
		return getValue("tokens");
	}
	
	function addTokens(amount) {
		if (amount === "" || isNaN(amount))
			return;
		
		setValue("tokens", tokens() + amount);
	}
	
	function setTokens(amount) {
		if (amount === "" || isNaN(amount))
			return;
		
		setValue("tokens", amount);
	}
	
	function clearData() {
		console.warn("Clearing data!");
		storage.clearAll();
		storage.fillDefaults();
		
//		JFractons.fCurrent = defaultKeys.fCurrent;
		JFractons.loadFractons();
		JGameAchievements.loadAchievements();
		JGameStatistics.loadStatistics();
		JQuests.loadNewQuests();
	}
	
}
