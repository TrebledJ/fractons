pragma Singleton
import QtQuick 2.0

Item {
	id: item
	
	property alias recentNotificationsModel: recentNotificationsModel
	property int unread: 0
	
	function notify(title, msg, submessage) {
		submessage = submessage || '';
		
		var obj = {
			role_title: title,
			role_message: msg,
			role_timestamp: Date.now(),
			role_submessage: submessage
		}

		recentNotificationsModel.insert(0, obj);
		unread++;
	}
	
	function markAsRead() { unread = 0; }
	function clearNotifications() { recentNotificationsModel.clear(); unread = 0; }
	
	Component.onCompleted: { console.warn("Reloading JGameNotifications..."); }
	
	ListModel { id: recentNotificationsModel }
	
}
