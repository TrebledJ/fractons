import Felgo 3.0
import QtQuick 2.11
import QtGraphicalEffects 1.0

import "../backdrops"
import "../../common"
import "../../game/singles"

import "../../js/Math.js" as JMath

SceneBase {
	id: sceneBase
	
	signal tokensButtonClicked
	signal goButtonClicked
	
	property int multiplier: 1
	property int rewardFractons: 0
	property int rewardTokens: 0
	
	property int tokens
	
	animationSmallerYBound: slotBackground.y + slotBackground.height
	animationLargerYBound: height
	
	
	onTokensChanged: JStorage.setTokens(tokens)
	
	Component.onCompleted: {
		tokens = JStorage.tokens();
	}
	
	Rectangle {
		id: panel
		width: parent.width; height: 50
		anchors.top: parent.top
		
		color: "navy"
		
		BubbleButton {
			id: tokensButton
			width: 40 + 10*(''+tokens).length; height: 30
			anchors {
				right: parent.right; rightMargin: 10
				verticalCenter: parent.verticalCenter
			}
			
			image.source: "qrc:/assets/icons/coins"
			image.anchors.rightMargin: width /2
			textObj.anchors.right: tokensButton.right
			textObj.anchors.leftMargin: width * 1/3
			text: tokens
			
//			onClicked: tokensButtonClicked()
			onClicked: tokens += 5	//	TODO comment
		}
		
	}
	
	Rectangle {
		x: slotBackground.x + slotBackground.width / 4 - width/2; width: 5
		anchors.top: panel.bottom; anchors.bottom: slotBackground.top
		color: slotBackground.color
	}
	
	Rectangle {
		x: slotBackground.x + slotBackground.width * 3 / 4 - width/2; width: 5
		anchors.top: panel.bottom; anchors.bottom: slotBackground.top
		color: slotBackground.color
	}
	
	Rectangle {
		radius: 10
		anchors.fill: slotBackground
		anchors.margins: -5
		
		RadialGradient {
			id: gradient
			anchors.fill: parent
			horizontalRadius: verticalRadius * 0.5
			
			gradient: Gradient {
				GradientStop { position: 0.000; color: Qt.rgba(1, 0, 0, 1) }
				GradientStop { position: 1.000; color: Qt.rgba(1, 1, 0, 1) }
			}
			
			SequentialAnimation {
				id: sequentialAnimation
				loops: Animation.Infinite
				running: true
				NumberAnimation {
					id: gradientAnimation
					target: gradient
					property: "angle"
					easing.overshoot: 2
					duration: 3000
					from: 0
					to: 180
					easing.type: Easing.OutInBack
				}
			}
		}
		
	}
	
	Rectangle {
		id: slotBackground
		width: 3*slotMachine.defaultReelWidth + 60; height: slotMachine.defaultItemHeight + 60
		radius: 5
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top: panel.bottom
		anchors.topMargin: 10
		color: "navy"
		
		SlotMachine  {
			id: slotMachine
			anchors.fill: slotBackground
			height: defaultItemHeight + 20
			reelsAnchors.margins: 30
			
			property int itemSize: 60
			
			defaultReelWidth: itemSize
			defaultItemHeight: itemSize + 10
//			reelStopDelay: 1500		//	reels are stopped separately by 1.5 seconds
			reelStopDelay: 800		//	reels are stopped separately by 1.5 seconds
			reelCount: 3
			rowCount: 1
			
			spinVelocity: 1000
			
			model: SlotMachineModel {
				symbols: {
					'fracton':	{ frequency: 1, data: { source: '', alt: 'ƒ' } },
					'token':	{ frequency: 1, data: { source: 'qrc:/assets/icons/coins', alt: 'T' } },
					'one':		{ frequency: 2, data: { source: '', alt: '1' } },
					'zero':		{ frequency: 3, data: { source: '', alt: '0' } },
					'pi':		{ frequency: 1, data: { source: '', alt: 'π' } },
					'e':		{ frequency: 1, data: { source: '', alt: 'e' } },
					'i':		{ frequency: 1, data: { source: '', alt: 'i' } },
				}
			}
			
			delegate: Item {
				width: slotMachine.defaultReelWidth; height: slotMachine.defaultItemHeight
				BubbleButton {
					id: button
					anchors.fill: parent
					anchors.margins: 10
					image.source: modelData.data.source
					text: modelData.data.source !== '' ? '' : modelData.data.alt
					bubbleOn: false
				}
				
				function animate(from, to) {
					button.animateScalar(from, to);
				}
			}
			
			onSpinEnded: {
				
				var middle = [];
				
				for (var r = 0; r < slotMachine.reelCount; r++)
				{
					var item = slotMachine.getItem(r, 0);
					item.animate(0.8, 1.2);
					
					middle.push(slotMachine.getItemData(r, 0));
				}
				
				evaluate(middle);
			}
		}
		
		//	borders, placed below slotMachine to ensure that it overlaps
		Row {
			anchors.centerIn: parent
			Repeater {
				model: 3
				Rectangle {
					width: slotMachine.defaultReelWidth; height: slotMachine.defaultItemHeight
					radius: 5
					color: "transparent"
					border.width: 8
					border.color: "skyblue"
				}
			}
		}
		
		MouseArea {
			anchors.fill: parent
			onClicked: goButtonClicked()
		}
	}
	
	
	TextBase {
		id: displayText
		anchors.centerIn: displayWidget
		color: "navy"
		visible: !displayWidget.visible && text != ""
	}
	
	Rectangle {
		id: displayWidget
		
		width: slotBackground.width + 60; height: 80
		anchors {
			top: slotBackground.bottom; topMargin: 10
			horizontalCenter: slotBackground.horizontalCenter
		}
		radius: 5
		
		color: "transparent"
		visible: !slotMachine.spinning && (rewardFractons || rewardTokens)
		
		property color textColor: "navy"
		
		Row {
			anchors.centerIn: parent
			spacing: 30
			
			Column {
				TextBase {
					text: rewardFractons + '   ƒ'
					font.pointSize: 18
					color: "navy"
					visible: rewardFractons
				}
				
				Row {
					spacing: 10
					TextBase {
						text: rewardTokens
						font.pointSize: 18
						color: "navy"
						visible: rewardTokens
					}
					Image {
						width: height; height: parent.height
						source: "qrc:/assets/icons/coins"
					}
				}
				
			}
			
			Column {
				spacing: -15
				
				TextBase {
					anchors.horizontalCenter: parent.horizontalCenter
					text: '×' + multiplier
					font.italic: true
				}
				
				Image {
					width: 80; height: 30
					mipmap: true
					source: 'qrc:/assets/img/right-arrow-navy.png'
				}
				
				
			}

			Column {
				TextBase {
					text: rewardFractons * multiplier + '   ƒ'
					font.pointSize: 18
					color: "navy"
					visible: rewardFractons
				}
				
				Row {
					spacing: 10
					TextBase {
						text: rewardTokens * multiplier
						font.pointSize: 18
						color: "navy"
						visible: rewardTokens
					}
					Image {
						width: height; height: parent.height
						source: "qrc:/assets/icons/coins"
					}
				}
			}
		}
	}
	
	onGoButtonClicked: {
		if (slotMachine.stopping)
			return;
		
		if (slotMachine.spinning)
			slotMachine.stop();
		else
		{
			if (tokens <= 0)
			{
				displayText.text = "Not enough tokens.";
				return;
			}
			
			//	QUEST : key = lottery
			JQuests.addQuestProgressByKey("lottery", 1);
			
			tokens -= 1;	//	deduct one token
			
			//	run normal circular animation
			if (gradientAnimation.easing.type !== Easing.OutInBack && gradientAnimation.duration !== 5000)
//				setGradientAnimation(Easing.OutInBack, 5000);
				setGradientAnimation(Easing.OutInBack, 2000);
			
			//	silence reward texts
			displayText.text = "";

			//	compute sum
			var obj = slotMachine.model.symbols;
			var sum = Object.keys(obj).reduce(function(acc, item) { return acc + obj[item].frequency; }, 0);
			console.log("Spinning wheel with", sum, "items in reel.")
			
			slotMachine.spin(10000);		//	defaults to stopping after 10 seconds
		}
		
//		slotMachine.updateModels();
	}
	
	onStateChanged: {
		if (state === "show")
		{
			//	refresh tokens
			tokens = JStorage.tokens();
			
			//	hide text
			displayText.text = "";
			
			//	reset variables
			rewardFractons = rewardTokens = 0;
			multiplier = 1;
		}
	}
	
	function setGradientAnimation(easingType, duration) {
		gradientAnimation.easing.type = easingType;
		gradientAnimation.duration = duration;
		
		sequentialAnimation.stop();
		sequentialAnimation.start();
	}
	
	function evaluate(items) {
		console.log("Items:", items[0].type, items[1].type, items[2].type);
		
		rewardFractons = 0;
		rewardTokens = 0;
		multiplier = 1;
		
		if (items[0].type === items[1].type && items[1].type === items[2].type)
			multiplier += 1;
		
		var count = {
			fracton: 0,
			token: 0,
			one: 0,
			zero: 0,
			pi: 0,
			e: 0,
			i: 0,
		};
		
		count[items[0].type]++;
		count[items[1].type]++;
		count[items[2].type]++;
		
		if (count.fracton === 3) { rewardFractons = 300; }
		else if (count.token === 3) { rewardTokens = 3; }
		else if (count.one === 3) { rewardFractons = 3; }
		else if (count.zero === 3) { rewardFractons = 1; }
		else if (count.pi === 3) { rewardFractons = 30; rewardTokens = 2; multiplier += 3; }
		else if (count.e === 3) { rewardFractons = 20; rewardTokens = 1; multiplier += 3; }
		else if (count.i === 3) { rewardFractons = 40; multiplier += 3; }
		else if (count.fracton === 2 && count.one === 1) { rewardFractons = 50; }
		else if (count.fracton === 2 && count.zero === 1) { rewardFractons = 10; }
		else if (count.fracton === 2 && count.pi === 1) { rewardFractons = 20; }
		else if (count.fracton === 2 && count.e === 1) { rewardFractons = 20; }
		else if (count.fracton === 2 && count.i === 1) { rewardFractons = 20; }
		else if (count.fracton === 2 && count.token === 1) { rewardFractons = 20; rewardTokens = 1; }
		else if (count.fracton === 1 && count.one === 2) { rewardFractons = 25; }
		else if (count.fracton === 1 && count.zero === 2) { rewardFractons = 5; }
		else if (count.fracton === 1 && count.pi === 2) { rewardFractons = 5; }
		else if (count.fracton === 1 && count.e === 2) { rewardFractons = 5; }
		else if (count.fracton === 1 && count.i === 2) { rewardFractons = 5; }
		else if (count.fracton === 1 && count.token === 2) { rewardFractons = 5; rewardTokens = 2; }
		else if (count.fracton === 1) { rewardFractons = 1; }
		else if (count.pi === 1 && count.e === 1 && count.i === 1) { rewardFractons = 100; }
		
		//	ACVM : binary
		if (count.zero + count.one === 3)
			JGameAchievements.addProgressByName("binary", 1);
		
		//	ACVM : magic numbers
		if (count.e === 1 && count.pi === 1 && count.i === 1)
			JGameAchievements.addProgressByName("magic numbers", 1);
		
		//	ACVM : big multiplier
		if (multiplier >= 5)
			JGameAchievements.addProgressByName("big multiplier", 1);
		
		//	ACVM : jackpot
		if (count.fractons === 3)
			JGameAchievements.addProgressByName("jackpot", 1);
		
		//	send rewards with multiplier
		JFractons.addFractons(rewardFractons * multiplier);
		tokens += rewardTokens * multiplier;
		
		if (rewardFractons || rewardTokens)
			setGradientAnimation(Easing.Linear, 300);
		else
			displayText.text = 'Sorry, try again.';
		
		//	ACVM : lucky
		if (rewardFractons * multiplier >= 100)
			JGameAchievements.addProgressByName("lucky", 1);
		
	}
	
}
