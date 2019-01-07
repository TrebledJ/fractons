import VPlay 2.0
import QtQuick 2.0

import "common"
import "scenes"
import "scenes/modes" as Modes

//	TODO create an accounts feature that will let users switch accounts (locally, of course)

GameWindow {
	id: gameWindow
	
	// You get free licenseKeys from https://v-play.net/licenseKey
	// With a licenseKey you can:
	//  * Publish your games & apps for the app stores
	//  * Remove the V-Play Splash Screen or set a custom one (available with the Pro Licenses)
	//  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
	//licenseKey: "<generate one from https://v-play.net/licenseKey>"
	
	// the size of the Window can be changed at runtime by pressing Ctrl (or Cmd on Mac) + the number keys 1-8
	// the content of the logical scene size (480x320 for landscape mode by default) gets scaled to the window size based on the scaleMode
	// you can set this size to any resolution you would like your project to start with, most of the times the one of your main target device
	// this resolution is for iPhone 4 & iPhone 4S
	screenWidth: 960
	screenHeight: 640
	
	state: "exerciseMenu"
//	state: "mode_standard"
	states: [
		State {
			name: "home"
			PropertyChanges { target: homeScene; opacity: 1 }
			PropertyChanges { target: gameWindow; activeScene: homeScene }
		},
		State {
			name: "exerciseMenu"
			PropertyChanges { target: exerciseMenuScene; opacity: 1 }
			PropertyChanges { target: gameWindow; activeScene: exerciseMenuScene }
		},
		State {
			name: "mode_standard"
			PropertyChanges { target: modeStandardScene; opacity: 1 }
			PropertyChanges { target: gameWindow; activeScene: modeStandardScene }
		},
		State {
			name: "mode_bar"
			PropertyChanges { target: modeBarScene; opacity: 1 }
			PropertyChanges { target: gameWindow; activeScene: modeBarScene }
		}
	]
	
	HomeScene {
		id: homeScene
		onExercisesButtonClicked: gameWindow.state = "exerciseMenu"
//		onStudyButtonClicked: gameWindow.state = "studyMenu"
		
	}
	
	ExerciseMenuScene {
		id: exerciseMenuScene
		
		onBackButtonClicked: gameWindow.state = "home"
		onModeClicked: {
			console.debug("Mode: '" + mode + "'");
			gameWindow.state = "mode_" + String(mode).toLowerCase()
		}
	}
	
	Modes.Standard {
		id: modeStandardScene
		
		onBackButtonClicked: gameWindow.state = "exerciseMenu"
		
	}
	
	Modes.Bar {
		id: modeBarScene
		
		onBackButtonClicked: gameWindow.state = "exerciseMenu"
	}
	
	/*
	Scene {
		id: scene
		
		// the "logical size" - the scene content is auto-scaled to match the GameWindow size
		width: 480
		height: 320
		
		// background rectangle matching the logical scene size (= safe zone available on all devices)
		// see here for more details on content scaling and safe zone: https://v-play.net/doc/vplay-different-screen-sizes/
		Rectangle {
			id: rectangle
			anchors.fill: parent
			color: "grey"
			
			Text {
				id: textElement
				// qsTr() uses the internationalization feature for multi-language support
				text: qsTr("Hello V-Play World")
				color: "#ffffff"
				anchors.centerIn: parent
			}
			
			MouseArea {
				anchors.fill: parent
				
				// when the rectangle that fits the whole scene is pressed, change the background color and the text
				onPressed: {
					textElement.text = qsTr("Scene-Rectangle is pressed at position " + Math.round(mouse.x) + "," + Math.round(mouse.y))
					rectangle.color = "black"
					console.debug("pressed position:", mouse.x, mouse.y)
				}
				
				onPositionChanged: {
					textElement.text = qsTr("Scene-Rectangle is moved at position " + Math.round(mouse.x) + "," + Math.round(mouse.y))
					console.debug("mouseMoved or touchDragged position:", mouse.x, mouse.y)
				}
				
				// revert the text & color after the touch/mouse button was released
				// also States could be used for that - search for "QML States" in the doc
				onReleased: {
					textElement.text = qsTr("Hello V-Play World")
					rectangle.color = "grey"
					console.debug("released position:", mouse.x, mouse.y)
				}
			}
		}// Rectangle with size of logical scene
		
		Image {
			id: vplayLogo
			source: "../assets/vplay-logo.png"
			
			// 50px is the "logical size" of the image, based on the scene size 480x320
			// on hd or hd2 displays, it will be shown at 100px (hd) or 200px (hd2)
			// thus this image should be at least 200px big to look crisp on all resolutions
			// for more details, see here: https://v-play.net/doc/vplay-different-screen-sizes/
			width: 50
			height: 50
			
			// this positions it absolute right and top of the GameWindow
			// change resolutions with Ctrl (or Cmd on Mac) + the number keys 1-8 to see the effect
			anchors.right: scene.gameWindowAnchorItem.right
			anchors.top: scene.gameWindowAnchorItem.top
			
			// this animation sequence fades the V-Play logo in and out infinitely (by modifying its opacity property)
			SequentialAnimation on opacity {
				loops: Animation.Infinite
				PropertyAnimation {
					to: 0
					duration: 1000 // 1 second for fade out
				}
				PropertyAnimation {
					to: 1
					duration: 1000 // 1 second for fade in
				}
			}
		}
		
	}
	*/
}


//import QtQuick 2.0
//import QtQuick.Window 2.0
//import QtQuick.Controls 2.0
//import QtQuick.Controls 1.4

//Window {
//	Page {
//		id: realtimeCalendarPage
		
//		property var dayCycleArr: ["Full Day", "Half Day (AM)", "Half Day (PM)"]
//		property int currCycleIndex: 0
		
//		rightBarItem: NavigationBarItem {
//		  contentWidth: saveButton.width
//		  AppButton {
//			  id: saveButton
//			  text: "Save & Request"
//						onClicked: {
//				userData = ({"date": calendar.selectedDate, "name": userName + userSurname, "details": dayCycle.text});
//				console.log(JSON.stringify(userData))
//				addNewCalendarItem(userData);
//			  }
//		   }
//		}
		
//		AppButton {
//			id: dayCycle
//			text:  dayCycleArr[currCycleIndex]
//					onClicked: {
//					 if(currCycleIndex ==  dayCycleArr.length - 1)
//					   currCycleIndex = 0;                 
//					 else
//					   currCycleIndex++; 
//				   }
//		}
		
//		Flow {
//			id: row
//			anchors.fill: parent
//			spacing: 10
//			layoutDirection: "RightToLeft"
//			Calendar {
//				id: calendar
//				width: (parent.width > parent.height ? parent.width * 0.6 - parent.spacing : parent.width)
//				height: (parent.height > parent.width ? parent.height * 0.6 - parent.spacing : parent.height)
//				selectedDate: new Date()
//				weekNumbersVisible: true
//				focus: true
//				onSelectedDateChanged: {
//					const day = selectedDate.getDate();
//					const month = selectedDate.getMonth() + 1;
//					const year = selectedDate.getFullYear();
//				}
		
//			   style: CalendarStyle {
//				   dayOfWeekDelegate: Item {
//					   height: dp(30)
//					   width: parent.width
//					   Rectangle {
//						   height: parent.height
//						   width: parent.width
//						   anchors.fill: parent
//						   Label {
//							   id: dayOfWeekDelegateText
//							   text: Qt.locale().dayName(styleData.dayOfWeek, Locale.ShortFormat)
//							   anchors.centerIn: parent
//							   color: "black"
//						   }
//					   }
//				   }
//				   dayDelegate: Item {
//					   id: container
//					   readonly property color sameMonthDateTextColor: "#444"
//					   readonly property color previousDateColor: "#444"
//					   readonly property color selectedDateColor: "#20d5f0"
//					   readonly property color selectedDateTextColor: "white"
//					   readonly property color differentMonthDateTextColor: "#bbb"
//					   readonly property color invalidDatecolor: "#dddddd"
		
//					   Rectangle {
//						   id: calendarMarker
//						   property bool isConfirmed: false
//						   visible: arrayFromFireBase.indexOf(styleData.date.getTime()) > -1
//						   anchors.fill: parent
//						   anchors.margins: -1
//						   color: calendarListModel.status ? "#4286f4" : "red"}
		
//					   Label {
//						   id: dayDelegateText
//						   text: styleData.date.getDate()
//						   anchors.centerIn: parent
//						   color:  {
//							   var color = invalidDatecolor;
//							   if (styleData.valid) {
//								   color = styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor ;
//								   if (styleData.selected) {
//									   color = selectedDateTextColor;
//								   }
//							   }
//							   color ;
//							}
//						}
//					}
//				}
//			}
//			Component {
//				id: eventListHeader
//				Row {
//					id: eventDateRow
//					width: parent.width
//					height: eventDayLabel.height
//					spacing: 10
//					Label {
//						id: eventDayLabel
//						text: calendar.selectedDate.getDate()
//						font.pointSize: 35
//						color: "black"
//					}
//					Column {
//						height: eventDayLabel.height
//						Label {
//							readonly property var options: { weekday: "long" }
//							text: Qt.locale().standaloneDayName(calendar.selectedDate.getDay(), Locale.LongFormat)
//							font.pointSize: 18
//							color: "black"
//						}
//						Label {
//							text: Qt.locale().standaloneMonthName(calendar.selectedDate.getMonth())
//								  + calendar.selectedDate.toLocaleDateString(Qt.locale(), " yyyy")
//							font.pointSize: 12
//							color: "black"
//						}
//					}
//				}
//			}
//			Rectangle {
//				width: (parent.width > parent.height ? parent.width * 0.4 - parent.spacing : parent.width)
//				height: (parent.height > parent.width ? parent.height * 0.4 - parent.spacing : parent.height)
//				ListView {
//					id:eventListView
//					spacing: 4
//					clip: true
//					anchors.fill: parent
//					anchors.margins: 10
//					model: calendarListModel
//					delegate: Rectangle {
//						width: eventListView.width
//						height: eventItemColumn.height
//						anchors.horizontalCenter: parent.horizontalCenter
//						Rectangle {
//							width: parent.width
//							height: 1
//							color: "#eee"
//						Column {
//							id: eventItemColumn
//							anchors.left: parent.left
//							anchors.leftMargin: 20
//							anchors.right: parent.right
//							height: timeLabel.height + nameLabel.height + 8
//							Label {
//								id: nameLabel
//								width: parent.width
//								wrapMode: Text.Wrap
//								text: modelData.name
//								color: "black"
//							}
//							Label {
//								id: timeLabel
//								width: parent.width
//								wrapMode: Text.Wrap
//								text: modelData.details
//								color: "#aaa"
//							  }
//						   }
//						}
//					}
//				}
//			}
//		}
//	}
//}
