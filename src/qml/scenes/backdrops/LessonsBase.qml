import QtQuick 2.11
import QtQuick.Controls 2.2

import "../../common"
import "../../game/singles"


import QtQuick 2.0
import QtQuick.Layouts 1.3

import "../backdrops"
import "../../common"
import "../../graphicmath"

import "../../js/Fraction.js" as JFraction

/*
Template for Lessons:

import QtQuick 2.0
import QtQuick.Layouts 1.3

import "../backdrops"
import "../../common"
import "../../graphicmath"

import "../../js/Fraction.js" as JFraction

LessonsBase {
	id: lessonsBase
	
	lessonName: "<lesson-name-here>"
	gotoMode: "<practice-mode-here>"
	gotoDifficulty: "<practice-difficulty-here>"
	
	Column {
		id: lessonContents
		width: parent.width
		spacing: 10
		
		ParagraphText {
			text: "The <b>numerator</b> represents the number of equal parts of a whole. The <b>denominator</b> represents the <i>total</i> number of equal parts in a whole. Together, the numerator and denominator make up a <b>fraction</b>, which represents a part of the whole."
		}
		
		Fraction {
			fraction: new JFraction.Fraction(2, 5)
		}
		
		
	}	//	Column
	
}
*/


SceneBase {
	id: sceneBase
	
	signal previousLessonButtonClicked
	signal nextLessonButtonClicked
	signal practiceButtonClicked(string mode, string difficulty)
	default property alias lessonItems: flickable.children
	
	property string lessonName
	property string gotoMode
	property string gotoDifficulty
	property alias flickable: flickable
	property bool useDefaultPracticeButton: true
	
	onShownChanged: {
		if (shown)
			JGameAchievements.addProgressByName("lessons?", 1);	//	ACVM : lessons?
	}
	
	onLessonItemsChanged: {
		if (lessonItems[1] !== undefined)
			lessonItems[1].parent = flickable.contentItem;
	}
	
	onPracticeButtonClicked: gotoExercise(mode, difficulty)
	
	Flickable  {
		id: flickable
		anchors { fill: parent; margins: 10; topMargin: header.height + 10 }
		contentWidth: width; contentHeight: lessonContents.height	//	contents is aliased to inherited lesson
		bottomMargin: 50	//	leave room for the previous/next buttons
		
		//	rectangular container for previous/next buttons
		Rectangle {
			anchors.top: flickable.contentItem.bottom
			width: parent.width; height: 40
			color: "transparent"
			
			visible: false	//	TODO uncomment and make prev/next buttons workable
			
			BubbleButton {
				anchors { verticalCenter: parent.verticalCenter; left: parent.left }
				width: 60; height: 30
				text: "Previous"
				onClicked: previousLessonButtonClicked()
			}
			
			BubbleButton {
				anchors { verticalCenter: parent.verticalCenter; right: parent.right }
				width: 60; height: 30
				text: "Next"
				onClicked: nextLessonButtonClicked()
			}
			
		}	//	Rectangle
	}	//	Flickable: flickable
	
	
	//	header bar
	Rectangle {
		id: header
		anchors.top: parent.top
		width: parent.width; height: 50
		color: "navy"
		
		TextBase {
			id: titleText
			anchors.centerIn: parent
			text: lessonName
			color: "yellow"
			font { bold: true; pointSize: lessonName.length < 30 ? 18 : lessonName.length < 50 ? 14 : 12 }
		}
		
		BubbleButton {
			anchors { top: parent.top; right: parent.right; margins: 5 }
			width: height; height: parent.height - 2*anchors.margins
			
			visible: useDefaultPracticeButton
			image.source: "qrc:/assets/icons/star"
			onClicked: {
				if (gotoMode === "")
				{
					console.error("GoToMode expected.");
					return;
				}

				practiceButtonClicked(gotoMode, gotoDifficulty)
			}
		}	//	BubbleButton
	}	//	Rectangle
	
}
