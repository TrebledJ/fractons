import VPlay 2.0
import QtQuick 2.0
import QtQuick.Controls 2.4

import "../../common"
import "../../game"

import "../../js/Math.js" as JMath

SceneBase {
	id: scene
	
	signal backButtonClicked
	signal difficultyChanged(int index, string difficulty)
	
	property alias panel: panel
	property alias goButton: goButton
	property alias answerField: answerField
	
	property alias drawingArea: drawingArea
	
	property alias numberPadVisible: numberPadSwitch.checked
	
	
	property var difficulties: []
	property int difficultyIndex: 0

	property bool hasInputError: false
	property string errorMessage
	
	property int combo: 0
	
	Component.onCompleted: {
		console.debug("Level", JStorage.level());
		console.debug("xp", JStorage.xpCurrent);
		console.debug("leveling_constant", JStorage.xpLevelingConstant);
		
//		for (var i = 0; i < 10; i++)
//		{
//			console.debug("Level", i, "has a thresh of", JStorage.xpThresh(i));
//		}
		
//		for (var i = 0; i < 20; i++)
//		{
//			console.debug("XP", i * 10, "has level", JStorage.level(i*10));
//		}
		
		console.warn("Current platform:", Qt.platform.os);
		//	see: http://doc.qt.io/qt-5/qml-qtqml-qt.html#platform-prop
		//	available enums: 
		//	 + android
		//	 + ios
		//	 + tvos
		//	 + linux
		//	 + osx
		//	 + qnx
		//	 + unix
		//	 + windows
		//	 + winrt
		
		//	check if platform is mobile
//		var mob = ["android", "ios", "tvos"];
		var isMobile = "android,ios,tvos".includes(Qt.platform.os);
		if (isMobile)
		{
			errorField.height = 30;
			errorField.font.pixelSize = 12;
			
			answerField.height = 30;
			answerField.font.pixelSize = 18;
		}
		else	//	non-mobile
		{
			numberPadVisible = false;	//	computers default to no numpad
			
			answerField.onEditingFinished.connect(function(){ goButton.clicked(); });
		}
	}
	
//	MouseArea {
//		anchors.fill: parent
		
//	}
	
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
			
			//	this is the row of buttons at the top of the panel
			Row {
				width: parent.width; height: 30
				spacing: 10
				
				BubbleButton {
					id: backButton
					width: parent.width - parent.spacing - infoButton.width; height: parent.height
					background.radius: 5
					
					text: "Back"
					color: "yellow"
					
					onClicked: backButtonClicked()
				}
				
				BubbleButton {
					id: infoButton
					width: height; height: parent.height
					background.radius: 5
					
					text: "i"
					color: "yellow"
				}
			}
			
			BubbleButton {
				id: difficultyButton
				width: parent.width; height: 30
				background.radius: 5
				
				text: difficulties.length === 0 ? "" : difficulties[difficultyIndex]
				color: "yellow"
				
				visible: difficulties.length !== 0
				
				onClicked: {
					difficultyIndex++;
					if (difficultyIndex >= difficulties.length)
						difficultyIndex = 0;
				}
			}
			
			Row {
				width: parent.width; height: parent.height - parent.spacing - backButton.height
													-(difficultyButton.visible ? parent.spacing + difficultyButton.height : 0)
				spacing: 10
				
				//	this will display the xp
				Rectangle {
					id: xpOuterBar
					width: 10; height: parent.height
					radius: 5
					
					color: "lightgoldenrodyellow"
					
					Rectangle {
						id: xpMeter
						width: 4; height: (parent.height - 4.0) * JStorage.xpProgress()
						radius: 4
						anchors {
							left: parent.left
							right: parent.right
							bottom: parent.bottom
							margins: 2
						}
						
						color: "navy"
					}
				}	//	Rectangle: xpOuterBar
				
				//	this column will display miscellaneous objects
				//	 event logs, the Go button, level/xp labels
				Column {
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
					
					BubbleButton {
						id: goButton
						width: parent.width; height: 30
						background.radius: 5
						
						text: "Go"
						color: "yellow"
						
						onClicked: {
							animateScalar(pressedFrom, pressedTo);
						}
					}
					
					TextBase {
						id: xpDisplay
						height: 30
						anchors.horizontalCenter: parent.horizontalCenter
						
						text: 'Level ' + JStorage.level() + '   ' + JStorage.xpCurrent + '/' + JStorage.xpNextThresh() + " xp"
						color: "yellow"
						
						font.pixelSize: 10
						verticalAlignment: Text.AlignBottom
					}
					
					
				}	//	Column
			}	//	Row
		}	//	Column: panelColumn
	}	//	Rectangle: panel
	
	//	this column holds text fields, anchored to the bottom of the scene (for non-mobile/tvos platforms only)
	Column {
		id: textFieldColumn
		
		anchors.left: panel.right
		anchors.right: scene.right
		anchors.bottom: scene.bottom
		
		//	TODO make some animation for the error field so that it will slide above the answerField
		
		//	this will popup above the answerField below when there is an error message
		TextField {
			id: errorField
			width: parent.width; height: 20
			padding: 2
			
			text: errorMessage
			color: "red"
			
			font.pointSize: 8
			font.family: "Trebuchet MS"
			
			visible: errorMessage !== ""
			opacity: 0.8
			
			readOnly: true
		}
		
		//	this is similar to a qlineedit, and is where the user will enter input
		TextField {
			id: answerField
			
			width: parent.width; height: 20
			padding: 2
			
			placeholderText: "Answer"
			
			color: "navy"
			font.pointSize: 8
			font.family: "Trebuchet MS"
			
			//	onEditingFinished: goButton.clicked()	//	done now in scene::Component.onCompleted
			
			//	onTextChanged: console.debug("Text changed.", text);
			
			background: Rectangle {
				anchors.fill: parent
				
				color: "white"
				border.color: answerField.enabled ? "lightgrey" : "transparent"
				
				Rectangle {
					anchors.fill: parent
					anchors.margins: 1
					
					//	TODO find suitable substitute to "red"
					color: hasInputError ? "red" : answerField.enabled ? "green" : "white"
					opacity: 0.5
				}
			}
		}
	}
	
	BubbleButton {
		id: numberPadSwitch
		width: height; height: 30
		anchors {
			top: drawingArea.top
			right: drawingArea.right
			margins: 10
		}

		color: "navy"
		text: "C"
		textBase.color: "yellow"
		
		checked: true
		isCheckButton: true
		
		onClicked: {
//			numberPad.visible = !numberPad.visible;
			if (numberPad.visible)
				numberPad.animate();
		}
	}
	
	NumberPad {
		id: numberPad
		height: 150
		anchors {
			left: drawingArea.left
			right: drawingArea.right
			bottom: textFieldColumn.top
			margins: 5
		}
		
		visible: numberPadVisible
		
		onKeyPressed: /*params: {string key}*/ {
			if (key === 'back')
			{
				if (answerField.text.length > 0)
					answerField.text = answerField.text.substring(0, answerField.text.length - 1);
				
				return;
			}
			
			answerField.text += key;
		}
	}
	
	//	this will be referenced in child scenes for appropriate drawing points
	Rectangle {
		id: drawingArea
		anchors {
			left: panel.right
			right: scene.right
			top: scene.top
			bottom: ignoreItems ? scene.bottom : (numberPad.visible ? numberPad.top : textFieldColumn.top)
		}
		
		property bool ignoreItems: false
		
		color: "transparent"
	}
	
	//	an object to store private variables
	QtObject {
		id: priv
		
		property var eventTextComponent: Qt.createComponent("../../common/TextAnimation.qml")
		property int eventCounter: 0
	}
	
	onDifficultyIndexChanged: {
		modesBase.difficultyChanged(difficultyIndex, difficulties[difficultyIndex]);
	}
	
	//	this function will create animated text floating upwards across the eventSpace
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
	
	//	this will increment (or decrement) the xp variable and log the increase (or decrease)
	function addXp(amount) {
		if (isNaN(amount) || amount === "") {
			console.error("addXp(): Expected numeric amount, got", amount === "" ? "<empty>" : amount);
			return;
		}
		
		JStorage.addXp(amount);
		if (amount >= 0)
			logEvent('+' + amount + 'xp', "yellow", 8);
		else
			logEvent(amount + 'xp', "red", 8);
	}
	
	//	this will log the combo with a special emoticon format for milestones, such as the combos divisible
	//	by 5, 10, and 100
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
	
	function addCombo() {
		combo++;
		logCombo();
	}
	
	function resetCombo() {
		combo = 0;
		var expressions = [
					"Oh no!",
					"Oh no!",
					"Oops!",
					"Oh dear...",
					"Combo 0",
				];
		var emojis = [
					"😢",
					"😭",
					"😥",
					"😱"
				];
		logEvent(JMath.choose(expressions) + ' ' + JMath.choose(emojis), "red", 8);
	}
	
	//	this will modify properties such that there IS a state of error present
	function showInputError(msg) {
		errorMessage = msg;
		hasInputError = true;
	}
	
	//	this will modify properties such that there is NO state of error present
	function acceptInput() {
		errorMessage = "";
		hasInputError = false;
	}
	
	//	this will clear the input in answerField
	function clearInput() {
		answerField.clear();
	}
}
