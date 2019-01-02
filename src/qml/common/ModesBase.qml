import VPlay 2.0
import QtQuick 2.0
import QtQuick.Controls 2.4

import "../js/Math.js" as JMath

SceneBase {
	id: scene
	
	property alias panel: panel
	property alias goButton: goButton
	property alias answerField: answerField
	
	property int level: 1
	property int xp: 25
	property int maxXp: 100
	property int combo: 0
	
	MouseArea {
		anchors.fill: parent
		onClicked: {
//			console.log("Mouse @ ", mouseX, mouseY);
//			xp += 1;
			
//			logEvent("Hello", "yellow", 8);
			
			combo += 1;
			logCombo();
			
//			goButton.animateScalar();
		}
		
		onWheel: {
//			addXp(Math.floor(wheel.angleDelta.y));
		}
	}
	
	Rectangle {
		id: panel
		width: scene.width / 4
		anchors {
			top: scene.top
			left: scene.left
			bottom: scene.bottom
		}
		
		color: "navy"
		
		Column {
			id: panelColumn
			anchors.fill: parent
			anchors.margins: 10
			
			spacing: 10
			
			Row {
				width: parent.width
				height: 20
				
				spacing: 10
				
				BubbleButton {
					id: backButton
					width: parent.width - parent.spacing - infoButton.width; height: parent.height
					background.radius: 5
					
					color: "yellow"
					text: "Back"
				}
				
				BubbleButton {
					id: infoButton
					width: height; height: parent.height
					background.radius: 5
					
					color: "yellow"
					text: "i"
				}
			}
			
			Row {
				width: parent.width; height: parent.height - parent.spacing - backButton.height
				
				spacing: 10
				
				Rectangle {
					id: xpOuterBar
					width: 10; height: parent.height
					radius: 5
					
					color: "lightgoldenrodyellow"
					
					Rectangle {
						id: xpMeter
						width: 4; height: (parent.height - 4.0) * xp / maxXp
						radius: 4
						anchors {
							left: parent.left
							right: parent.right
							bottom: parent.bottom
							margins: 2
						}
						
						color: "navy"
					}
				}	//	Rectangle
				
				Column {
					id: colZ
					width: parent.width - parent.spacing - xpOuterBar.width; height: parent.height
					spacing: 10
					
					Rectangle {
						id: eventSpace
						width: parent.width
						height: parent.height - parent.spacing - goButton.height
									- parent.spacing - xpDisplay.height
						
						color: "skyblue"	//	debug
//						color: "transparent"
					}
					
					//	TODO consider: we can have combo as text? w/ larger font: COMBO 5
//					Rectangle {
//						id: comboSpace
//						width: parent.width; height: comboText.height + comboDisp.height
						
//						color: "skyblue"		//	debug
////						color: "transparent"
						
//						Column {
//							anchors.fill: parent
//							spacing: 2
							
//							TextBase {
//								id: comboText
//	//							anchors.top: parent.top
//								anchors.horizontalCenter: parent.horizontalCenter
								
//								text: "Combo"
//								horizontalAlignment: Text.AlignHCenter
//								verticalAlignment: Text.AlignVCenter
//							}
							
//							TextBase {
//								id: comboDisp
//	//							anchors.bottom: parent.bottom
//								anchors.horizontalCenter: parent.horizontalCenter
								
//								text: combo
//								font.pixelSize: combo % 5 == 0 ? 18 : 14
//							}
//						}
//					}
					
					BubbleButton {
						id: goButton
						width: parent.width; height: 20
						background.radius: 5
						
						color: "yellow"
						text: "Go"
						
						onClicked: {
							animateScalar(0.9, 1.05);
						}
					}
					
					TextBase {
						id: xpDisplay
						height: 30
						anchors.horizontalCenter: parent.horizontalCenter
						
						text: 'Level ' + level + '   ' + xp + '/' + maxXp + " xp"
						color: "yellow"
						
						font.pixelSize: 10
						verticalAlignment: Text.AlignBottom
					}
					
					
				}	//	Column
			}	//	Row
		}	//	Column

	}
	
	Column {
		id: textFieldColumn
		
		anchors.left: panel.right
		anchors.right: scene.right
		anchors.bottom: scene.bottom
		
		TextField {
			id: errorField
			width: parent.width; height: 20
			padding: 2
			
			color: "red"
			font.pointSize: 8
			font.family: "Trebuchet MS"
			
			visible: false
			opacity: 0.8
			
			readOnly: true
			onTextChanged: {
				visible = (text !== "");
			}
		}
		
		TextField {
			id: answerField
			
			width: parent.width; height: 20
			padding: 2
			
			color: "navy"
			font.pointSize: 8
			font.family: "Trebuchet MS"
			
			placeholderText: "Answer"
			
			onEditingFinished: {
				goButton.clicked()
			}
			
		}
	}
	
	QtObject {
		id: priv
		
		property var eventTextComponent: Qt.createComponent("../common/TextAnimation.qml")
		property int eventCounter: 0
	}
	
	function logEvent(text, color, fontSize) {
		text = text !== undefined ? text : "Hello world?";
		color = color !== undefined ? color : "yellow";
		fontSize = fontSize !== undefined ? fontSize : 12;
		
		priv.eventCounter++;
		
		var id = "eventText" + priv.eventCounter;
		
		var props = {
			id: id,
			text: text,
			color: color,
		};
		
		
		var obj = priv.eventTextComponent.createObject(eventSpace, props);
		
		obj.font.pixelSize = fontSize;
		
		var randY = JMath.randI(-25, -5);
		
		var from = eventSpace.height;
		var to = 20;
		
		obj.animation1.from = from + randY;
		obj.animation1.to = to + randY;
		
		
		obj.x = JMath.randI(0, eventSpace.width - 30);
		obj.horizontalAlignment = Text.AlignHCenter
		
		obj.start();
	}
	
	function addXp(amount) {
		if (isNaN(amount)) {
			console.error("AddXp(): Expected numeric amount, got", amount);
			return;
		}
		
		xp += amount;
		if (amount >= 0)
			logEvent('+' + amount + 'xp', "yellow", 8);
		else
			logEvent('' + amount + 'xp', "red", 8);
	}
	
	function logCombo(num) {
		num = num !== undefined ? num : combo;
		
		if (num % 100 == 0)
		{
			logEvent('Combo ' + num + ' ✨', "lightgoldenrodyellow", 16);
		}
		else if (num % 10 == 0)
		{
			logEvent('Combo ' + num + ' 💫', "lightgoldenrodyellow", 12);
		}
		else if (num % 5 == 0)
		{
			logEvent('Combo ' + num + ' 🌟', "lightgoldenrodyellow", 10);
		}
		else
		{
			logEvent('Combo ' + num + ' ⭐️', "yellow", 8);
		}
	}
	
	function showInputError(msg) {
		errorField.text = msg;
	}
	
	function acceptInput() {
		errorField.text = "";
	}
	
}
