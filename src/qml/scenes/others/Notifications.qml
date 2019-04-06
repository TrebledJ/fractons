import Felgo 3.0
import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "../backdrops"
import "../../common"
import "../../game/singles"

import "../../js/Utils.js" as JUtils

SceneBase {
	id: sceneBase
	
	useDefaultTopRibbon: true
	
	
	//	appears when listview contains no notifications
	TextBase {
		anchors.centerIn: parent
		text: "No Notifications"
		font.pointSize: 16
		visible: !listView.visible
	}
	
	onShownChanged: {
		if (shown)
			JGameNotifications.markAsRead();
	}
	
	
	ListView {
		id: listView
		anchors {
			top: banner.bottom; bottom: parent.bottom
			left: parent.left
			right: parent.right
		}
		
		topMargin: 10
		leftMargin: 10
		rightMargin: 10
		
		spacing: 10
		boundsBehavior: Flickable.StopAtBounds
		
		visible: count > 0
		
		ScrollBar.vertical: ScrollBar {
			anchors.right: listView.right
			active: true
		}
		
		model: JGameNotifications.recentNotificationsModel
		delegate: ItemDelegate {
			background: Rectangle {
				anchors.fill: parent
				visible: false
			}
			
			width: listView.width - listView.leftMargin - listView.rightMargin
			height: 50
			
			RowLayout {
				anchors.fill: parent
				spacing: 10
				
				ParagraphText {
					id: timestampText
					width: parent.width * 0.2; height: 50
					Layout.minimumWidth: Layout.maximumWidth
					Layout.maximumWidth: width
					
					text: JUtils.timeAgo(role_timestamp)
					font.pointSize: 9
					
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
					
					Timer {
						interval: 1 * 1000
						running: true
						repeat: true
						onTriggered: {
							timestampText.text = JUtils.timeAgo(role_timestamp);
						}
					}
				}
				
				ParagraphText {
					width: parent.width * 0.2; height: 50
					Layout.minimumWidth: Layout.maximumWidth
					Layout.maximumWidth: width
					
					text: role_title
					font.pointSize: 14
					
					verticalAlignment: Text.AlignVCenter
				}
				
				Column {
					height: 50
					Layout.fillWidth: true
					
					spacing: 2
					
					ParagraphText {
						width: parent.width; height: 30
						
						text: role_message
						font.pointSize: 11
						
						verticalAlignment: role_submessage ? Text.AlignBottom : Text.AlignVCenter
					}
					
					TextBase {
						width: parent.width; height: 18
						
						text: role_submessage
						font.pointSize: 8
						
						opacity: 0.5
						visible: role_submessage
					}
				}

				
				
			}	//	RowLayout
		}	//	ItemDelegate
		
	}	//	ListView
	
}	//	SceneBase
