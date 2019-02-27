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


Item {
	id: item
	
	readonly property bool isMobile: "android,ios,tvos,winrt".includes(Qt.platform.os);
	
	readonly property var defaultKeys: ({	//	object with key-value pairs of default values
											fCurrent: 0,
											fLevelingConstant: 25,
											combo: 0,
											
											achievements: {
												nou: {
													name: 'no u',
													description: 'no u',
													reward: 500,
													isSecret: true,
													secret: 'Input "no u".',
													isClassified: false,
													progress: 0,
													maxProgress: 5,
													isCollected: false
												},
												associate: {
													name: 'Associate',
													description: 'Correctly answer a question.',
													reward: 1,
													isSecret: false,
													secret: '',
													isClassified: false,
													progress: 0,
													maxProgress: 1,
													isCollected: false
												},
												sprinter1: {
													name: 'Sprinter I',
													description: 'Reach a combo of 3.',
													reward: 10,
													isSecret: false,
													secret: '',
													isClassified: false,
													progress: 0,
													maxProgress: 3,
													isCollected:false
												}
											},
											
//											stats_general: {
//												'2019-02-26': {
//													attempted: 0,
//													correct: 0,
//													fractonsEarned: 0
//												},
//											},
//											stats_questions: [
//												{
//													mode: 'Balance',
//													difficulty: '',
//													question: '2/4 = ?/2',
//													input: '1',
//													answer: '1',
//													isCorrect: true,
//												},
//											],
											stats_general: {
												
											},
											stats_questions: [
												
											],
											
										})
	
	property alias storage: storage
	
	Storage {
		id: storage
		databaseName: "data"
		
//		clearAllAtStartup: true	//	uncomment to clear db at startup
		
		onStorageError: {
			console.warn("Fractons:/game/singles/Storage.qml:Storage:storage ::: A storage error occured!");
			console.error(JSON.stringify(errorData));
		}
		
		function fillDefaults() {
			for (var key in defaultKeys)
			{
				setValue(key, defaultKeys[key]);
			}
		}
	}
	
	Component.onCompleted: {
		console.warn("Reloading JStorage...");
		
		
		//	see [1]
		console.warn("Current platform:", Qt.platform.os);
		
		//	checking keys
		console.log("Checking keys...");
		for (var k in defaultKeys)
		{
			var res = getValue(k);
			if (res === undefined)
			{
				console.log("Key", k, "is undefined.");
				setValue(k, defaultKeys[k]);
			}
		}
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
	
	function clearData() {
		console.warn("Clearing data!");
		storage.clearAll();
		storage.fillDefaults();
		
//		JFractons.fCurrent = defaultKeys.fCurrent;
		JFractons.loadFractons();
		JGameAchievements.loadAchievements();
		JGameStatistics.loadStatistics();
	}
	
}
