import VPlay 2.0
import QtQuick 2.0
import QtQuick.Layouts 1.3

import "../backdrops"
import "../../common"
import "../../graphicmath"

import "../../js/Fraction.js" as JFraction

LessonsBase {
	id: lessonsBase
	
	lessonName: "Introduction to Fractions"
	
	useDefaultPracticeButton: false
	
	Column {
		id: lessonContents
		width: parent.width
		spacing: 10
		
		Row {
			width: parent.width
			anchors.horizontalCenter: parent.horizontalCenter
			spacing: 10
			
			ParagraphText {
				width: parent.width - 160 - 20
				anchors.verticalCenter: parent.verticalCenter
				text: "How do we mathematically represent pizzas? On first thought, it seems that we can easily represent <i>whole</i> pizzas by using <i>whole numbers</i>. For example, the two pizzas on the right could be represented as the number 2."
			}
			
			Image {
				width: height; height: 80
				source: "../../../assets/lessons/pizza/5of5.png"
			}
			
			Image {
				width: height; height: 80
				source: "../../../assets/lessons/pizza/5of5.png"
			}
		}
		
		Row {
			width: parent.width
			anchors.horizontalCenter: parent.horizontalCenter
			spacing: 10
			
			ParagraphText {
				width: parent.width - 120 - 10
				anchors.verticalCenter: parent.verticalCenter
				text: "But what if we wanted to represent a <i>part</i> or <i>section</i> of the pizza? For example, what if we only wanted a half of the pizza? How might we quantify and represent that? This leads us to the concept of fractions."
			}
			
			Image {
				width: height; height: 120
				source: "../../../assets/lessons/pizza/2of5.png"
			}
		}
		
		//	TODO have 1/2 pizzas (halves, not fifths)
		
//		ParagraphText {
//			text: "Each fraction has two parts: the numerator and the denominator."
//		}
		
		Row {
//			width: parent.width
			anchors.horizontalCenter: parent.horizontalCenter
			spacing: 20
			
			Fraction {
				fraction: new JFraction.Fraction(2, 5)
			}
			
			Fraction {
				fraction: new JFraction.Fraction("← numerator", "← denominator")
				vinculum.visible: false
			}
		
		}
		
		ParagraphText {
			text: "The <b>numerator</b> represents the number of equal parts of a whole. The <b>denominator</b> represents the <i>total</i> number of equal parts in a whole. Together, the numerator and denominator make up a <b>fraction</b>, which represents a part of the whole."
		}
		
		ParagraphText {
			text: "Fractions are clean-cut and used throughout mathematics. In the next lesson, you'll learn how to perform operations on fractions: addition, subtraction, multiplication, and division."
		}
		
	}	//	Column
	
}
