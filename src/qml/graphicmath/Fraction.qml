import VPlay 2.0
import QtQuick 2.0

import "../common"
import "../js/Fraction.js" as JFraction

Column {
	id: column
	width: 50
	spacing: 1
	
	property var fraction: new JFraction.Fraction(1, 2)
	
	MathText {
		id: numerator
		width: parent.width
		
		text: fraction.n
	}
	
	Rectangle {
		width: Math.max(numerator.contentWidth, denominator.contentWidth) + 10; height: 1
		anchors.horizontalCenter: parent.horizontalCenter
		
		color: "navy"
	}
	
	MathText {
		id: denominator
		width: parent.width
		
		text: fraction.d
	}
}
