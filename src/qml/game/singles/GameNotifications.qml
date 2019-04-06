pragma Singleton
import QtQuick 2.0

Item {
	id: item
	
	signal message(string title, string message, int seconds)
	
//	property var recentMessages: []
	
	property alias recentMessagesModel: recentMessagesModel
	
	Component.onCompleted: {
		console.warn("Reloading JGameNotifications...");
		
		sendMessage("Title A", "Message A");
		sendMessage("Title B", "Message B");
		sendMessage("A super duper long title.", "A super duper long message that will blow your brains out into the skies.");
	}
	
	ListModel {
		id: recentMessagesModel
	}
	
	function sendMessage(title, msg, unlocked) {
		unlocked = unlocked || '';
		
		var obj = {
			role_title: title,
			role_message: msg,
			role_timestamp: Date.now(),
			role_unlocked: unlocked
		}
		
		recentMessagesModel.append(obj);
	}
	
	function clearNotifications() {
		recentMessagesModel.clear();
	}
	
}
