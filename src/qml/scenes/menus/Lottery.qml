import Felgo 3.0
import QtQuick 2.0
import QtGraphicalEffects 1.0

import "../backdrops"
import "../../common"
import "../../game/singles"

SceneBase {
	id: sceneBase
	
	signal tokensButtonClicked
	signal goButtonClicked
	
	property int tokens: 5
	
	animationSmallerYBound: slotBackground.y + slotBackground.height
	animationLargerYBound: height
	
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
			horizontalRadius: verticalRadius / 2
			
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
					duration: 5000
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
	//		visible: false
			
			property int itemSize: 60
			
			defaultReelWidth: itemSize
			defaultItemHeight: itemSize + 10
			reelStopDelay: 1500		//	reels are stopped separately by 1.5 seconds
			reelCount: 3
			rowCount: 1
			
			model: SlotMachineModel {
				symbols: {
					'fracton':	{ frequency: 1, data: { source: '', alt: 'ƒ' } },
					'token':	{ frequency: 1, data: { source: 'qrc:/assets/icons/coins', alt: 'T' } },
					'star':		{ frequency: 1, data: { source: 'qrc:/assets/icons/star', alt: 's' } },
					'one':		{ frequency: 3, data: { source: '', alt: '1' } },
					'zero':		{ frequency: 3, data: { source: '', alt: '0' } },
	//				'plus':		{ frequency: 2, data: { source: '', alt: '+' } },
	//				'minus':	{ frequency: 2, data: { source: '', alt: '–' } },
	//				'times':	{ frequency: 2, data: { source: '', alt: '×' } },
	//				'divide':	{ frequency: 2, data: { source: '', alt: '÷' } },
					'pi':		{ frequency: 2, data: { source: '', alt: 'π' } },
					'e':		{ frequency: 2, data: { source: '', alt: 'e' } },
					'i':		{ frequency: 2, data: { source: '', alt: 'i' } },
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
	
	
	
	Row {
		anchors.top: slotBackground.top
		anchors.topMargin: 30
		anchors.left: slotBackground.left
		
		TextBase {
			id: rewardText
			text: ""
			font.pointSize: 16
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
				console.warn("Not enough tokens.");
				return;
			}
			
			tokens -= 1;	//	deduct one token
			
			//	run normal animation
			if (gradientAnimation.easing.type !== Easing.OutInBack && gradientAnimation.duration !== 5000)
				setGradientAnimation(Easing.OutInBack, 5000);
			
			//	compute sum
			var obj = slotMachine.model.symbols;
			var sum = Object.keys(obj).reduce(function(acc, item) { return acc + obj[item].frequency; }, 0);
			console.log("Spinning wheel with", sum, "items in reel.")
			slotMachine.spin(10000);		//	defaults to stopping after 10 seconds
		}
		
		slotMachine.updateModels();
	}
	
	
	function setGradientAnimation(easingType, duration) {
		gradientAnimation.easing.type = easingType;
		gradientAnimation.duration = duration;
		
		sequentialAnimation.stop();
		sequentialAnimation.start();
	}
	
	function evaluate(items) {
		console.log("Items:", items[0].type, items[1].type, items[2].type);
		
		var rewardFractons = 0, rewardTokens = 0, multiplier = 1;
		
		
		if (items[0].type === items[1].type && items[1].type === items[2].type)
		{
			multiplier += 1;
			
			//	run "excited" animation
			setGradientAnimation(Easing.Linear, 500);
		}
		
		var count = {
			fracton: 0,
			token: 0,
			star: 0,
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
		else if (count.token === 3) { rewardTokens = 5; }
		else if (count.i === 3) { rewardFractons = 10; rewardTokens = 1; }
		else if (count.fracton === 2 && count.star === 1) { rewardFractons = 200; }
		else if (count.fracton === 2 && count.one === 1) { rewardFractons = 50; }
		else if (count.fracton === 2 && count.pi === 1) { rewardFractons = 20; }
		else if (count.fracton === 2 && count.e === 1) { rewardFractons = 20; }
		else if (count.fracton === 2 && count.i === 1) { rewardFractons = 20; }
		else if (count.fracton === 2 && count.token === 1) { rewardTokens = 3; }
		else if (count.fracton === 1 && count.star === 2) { rewardFractons = 50; }
		else if (count.fracton === 1 && count.one === 2) { rewardFractons = 25; }
		else if (count.fracton === 1 && count.token === 2) { rewardTokens = 2; }
		else if (count.pi === 1 && count.e === 1 && count.i === 1) { rewardFractons = 100; }
		else if (count.token >= 1) { rewardTokens = 1; }
		
		rewardFractons += count.one;
		
		//	add multiplier
		rewardFractons *= multiplier;
		rewardTokens *= multiplier;
		
		
		console.log("Reward:");
		console.log("Fractons --", rewardFractons);
		console.log("Tokens --", rewardTokens);
		
		
		//	send rewards
		JFractons.addFractons(rewardFractons);
		tokens += rewardTokens;
		
	}
	
	
}
