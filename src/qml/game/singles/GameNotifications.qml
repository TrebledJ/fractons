pragma Singleton
import QtQuick 2.0

Item {
	id: item
	
	Component.onCompleted: {
		console.warn("Reloading JGameNotifications...");
	}
	
	signal message(string title, string message, int seconds)
	
	function sendMessage(title, msg, seconds) {
		message(title, msg, seconds);
	}
	
}
