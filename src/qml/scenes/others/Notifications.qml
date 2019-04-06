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
		
		model: JGameNotifications.recentMessagesModel
		delegate: ItemDelegate {
			background: Rectangle {
				anchors.fill: parent
				visible: false
			}
			
			width: listView.width - listView.leftMargin - listView.rightMargin
			height: 40
			RowLayout {
				anchors.fill: parent
			
				spacing: 10
				
				ParagraphText {
					id: timestampText
					width: parent.width * 0.2
					Layout.minimumWidth: Layout.maximumWidth
					Layout.maximumWidth: width
					
					height: 40
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
					width: parent.width * 0.2; height: 40
					Layout.minimumWidth: Layout.maximumWidth
					Layout.maximumWidth: width
					
					text: role_title
					font.pointSize: 14
					
					verticalAlignment: Text.AlignVCenter
				}
				
				ParagraphText {
					height: 40
					Layout.fillWidth: true
					
					text: role_message
					font.pointSize: 11
					
					verticalAlignment: Text.AlignVCenter
				}
				
			}	//	RowLayout
		}	//	ItemDelegate
		
	}	//	ListView
	
}	//	SceneBase
