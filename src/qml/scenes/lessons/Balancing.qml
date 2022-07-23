import QtQuick 2.0
import QtQuick.Layouts 1.3

import "../backdrops"
import "../../common"
import "../../graphicmath"

import "../../js/Fraction.js" as JFraction

LessonsBase {
	id: lessonsBase
	
	lessonName: "Balancing Fractions"
	gotoMode: "balance"
	gotoDifficulty: ""
	
	Column {
		id: lessonContents
		width: parent.width
		spacing: 10
		
		ParagraphText {
			text: "The following picture shows how one-half (1/2) is equal to two-fourths (2/4)."
		}
		
		//	TODO square or pizza image of 1/2 and 2/4
		
		ParagraphText {
			text: "Two fractions are <i>equal</i> if they precisely describe the same proportions. 
Both 1/2 and 2/4 were able to precisely describe the pizza above, so they must be equal. 
Mathematically, two fractions are equal if the <i>ratio</i> between the numerator and denominator are equal."
		}
		
		ParagraphText {
			text: "A rule of thumb is to remember that whatever is multiplied to the top (the numerator) 
must also be multiplied to the bottom (the denominator)."
		}
		
		Fraction {
			fraction: new JFraction.Fraction(2, 5)
		}
		
		
	}	//	Column
	
}
