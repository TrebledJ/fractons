//	Storage.qml

pragma Singleton
import VPlay 2.0
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
										 }
									 }
								 })
	
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
		
		
		//	see [1]
		console.warn("Current platform:", Qt.platform.os);
		
		
		//	checking keys
		console.log("Checking keys...");
		for (var k in defaultKeys)
		{
			var res = getValue(k);
//			console.log("Key", k, "is", JSON.stringify(res));
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
	
	
	
}
