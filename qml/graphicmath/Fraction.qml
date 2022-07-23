import QtQuick 2.0

import "../common"
import "../js/Fraction.js" as JFraction

Column {
	id: column
	width: Math.max(numerator.contentWidth, vinculum.width, denominator.contentWidth)
	height: numerator.contentHeight + spacing + vinculum.height + spacing + denominator.contentHeight
	
	property alias font: numerator.font
	property var fraction: new JFraction.Fraction(1, 2)
	property alias vinculum: vinculum
	
	MathText {
		id: numerator
		anchors.horizontalCenter: parent.horizontalCenter
		text: fraction.n
	}
	
	Rectangle {
		id: vinculum
		anchors.horizontalCenter: parent.horizontalCenter
		width: Math.max(numerator.contentWidth, denominator.contentWidth) + 10; height: 1 * numerator.height / 24
		color: "navy"
	}
	
	MathText {
		id: denominator
		anchors.horizontalCenter: parent.horizontalCenter
		text: fraction.d; font: numerator.font
	}
}
