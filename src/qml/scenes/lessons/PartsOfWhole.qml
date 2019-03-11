import QtQuick 2.0
import QtQuick.Layouts 1.3

import "../backdrops"
import "../../common"
import "../../graphicmath"

import "../../js/Fraction.js" as JFraction

LessonsBase {
	id: lessonsBase
	
	lessonName: "Fractions as Parts of a Whole"
	gotoMode: "fill"
	gotoDifficulty: ""
	
	Column {
		id: lessonContents
		width: parent.width
		spacing: 10
		
		ParagraphText {
			text: ""
		}
		
	}	//	Column
	
}
