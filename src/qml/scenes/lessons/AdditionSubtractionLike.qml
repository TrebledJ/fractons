import QtQuick 2.0
import QtQuick.Layouts 1.3

import "../backdrops"
import "../../common"
import "../../graphicmath"

LessonsBase {
	id: lessonsBase
	
	lessonName: "Adding and Subtracting Fractions of Like Denominators"
	
	gotoMode: "operations"
	gotoDifficulty: "easy"
	
	//	TODO consider writing/parsing a script with img tags, equations, and whatnot
	Column {
		id: lessonContents
		width: parent.width
		spacing: 10
		
		ParagraphText {
			text: "If two fractions have the same denominator, we say that the fractions have <i>like</i> denominators. 
To <b>add</b> two fractions with like denominators, we add the numerators together to get the resulting numerator. 
The denominator remains unchanged."
		}
		
		ParagraphText {
			text: "We can use pizzas to illustrate an example. Here, our pizzas are divided into fifths.
 The illustration below shows that if we have <b>one-fifth</b> of a pizza and another 
<b>two-fifths</b> of a pizza, combining them together gives us <b>three-fifths</b> of a pizza."
		}
		
		Row {
			anchors.horizontalCenter: parent.horizontalCenter
			spacing: 10
			
			Image {
				width: height; height: 120
				source: "../../../assets/lessons/pizza/1of5.png"
			}
			
			MathText {
				anchors.verticalCenter: parent.verticalCenter
				text: '+'
			}
			
			Image {
				width: height; height: 120
				source: "../../../assets/lessons/pizza/2of5.png"
			}
			
			MathText {
				anchors.verticalCenter: parent.verticalCenter
				text: '='
			}
			
			Image {
				width: height; height: 120
				source: "../../../assets/lessons/pizza/3of5.png"
			}
		}	//	Row
		
		ParagraphText {
			text: "This can be expressed using fractions."
		}
		
		Equation {
			anchors.horizontalCenter: parent.horizontalCenter
			text: '1/5 + 2/5 = 3/5'
		}
		
		ParagraphText {
			text: "Here, we've added the numerators, 1 and 2, together to get 3. We've left the denominator unchanged. 
Similarly, to <b>subtract</b> fractions of like denominators, we simply subtract the numerators, 
leaving the denominator unchanged. Try to answer the following question."
		}
		
		Row {
			width: parent.width
			anchors.horizontalCenter: parent.horizontalCenter
			spacing: 10
			
			ParagraphText {
				width: parent.width - 120 - 10
				anchors.verticalCenter: parent.verticalCenter
				text: "Martin and Naomi ordered a pizza and decided to each take a portion. 
Naomi likes pizza a lot, so she gets four-fifths of pizzas. How much pizza does Martin get?"
			}
			
			Image {
				width: height; height: 120
				source: "../../../assets/lessons/pizza/5of5.png"
			}
			
		}	//	Row
		
		ParagraphText {
			text: "If the pizza is divided into 5 equal slices, then <b>four-fifths</b> of the
 pizza would be 4 slices. If Naomi gets 4 slices, then there will only be 1 slice remaining. 
Thus, Martin gets 1 pizza slice, which is <b>one-fifth</b> of the pizza. We can also use fractions to express this."
		}
		
		Equation {
			anchors.horizontalCenter: parent.horizontalCenter
			text: '5/5 - 4/5 = 1/5'
		}
		
	}	//	Column
	
}
