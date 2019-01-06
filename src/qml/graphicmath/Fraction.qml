import VPlay 2.0
import QtQuick 2.0

import "../common"
import "../js/Fraction.js" as JFraction

Column {
	id: column
	width: Math.max(numerator.width, vinculum.width, denominator.width)
	
	property alias font: numerator.font
	
	property var fraction: new JFraction.Fraction(1, 2)
	
	MathText {
		id: numerator
		anchors.horizontalCenter: parent.horizontalCenter
		
		
		text: fraction.n
	}
	
	Rectangle {
		id: vinculum
		width: Math.max(numerator.contentWidth, denominator.contentWidth) + 10; height: 1
		anchors.horizontalCenter: parent.horizontalCenter
		
		color: "navy"
	}
	
	MathText {
		id: denominator
		anchors.horizontalCenter: parent.horizontalCenter
		
		text: fraction.d
		font: numerator.font
	}
}
