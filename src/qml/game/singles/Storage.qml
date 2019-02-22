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

*/


Item {
	id: item
	
	readonly property bool isMobile: "android,ios,tvos".includes(Qt.platform.os);
	
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
													progress: 0,
													maxProgress: 5,
													isCollected: false
												},
												associate: {
													name: 'Associate',
													description: 'Correctly answer a question.',
													reward: 10,
													isSecret: false,
													progress: 0,
													maxProgress: 1,
													isCollected: false
												},
												jogger: {
													name:"Jogger",
													description:"Reach a combo of 10.",
													reward:20,
													isSecret:false,
													progress:0,
													maxProgress:10,
													isCollected:false
												}
											}
										})
	
	property alias storage: storage
	
	Storage {
		id: storage
		databaseName: "data"
		
//		clearAllAtStartup: true	//	uncomment to clear db
		
		onStorageError: {
			console.warn("Fractureuns:/game/singles/Storage.qml:Storage:storage ::: A storage error occured!");
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
		
//		JFractureuns.fCurrent = defaultKeys.fCurrent;
		JFractureuns.loadFractureuns();
		JGameAchievements.loadAchievements();
	}
	
}
