import VPlay 2.0
import QtQuick 2.0

import "../../common"
import "../../graphicmath/" as GMath

import "../../js/Fraction.js" as JFraction

ModesBase {
	id: modesBase
	
//	property int mode
	
	Connections {
		target: modesBase.goButton
		
		onClicked: {
			var text = modesBase.answerField.text;
			
			if (text.length === 0)
			{
				modesBase.acceptInput();
				return;
			}
			
			console.debug("Validating input...");
			
			var errMsg = JFraction.isParsibleWithError(text);
			if (errMsg === "")
			{
				modesBase.acceptInput();
				
				var fraction = JFraction.parse(text);
				console.debug("Parsed fraction:", fraction);
			}
			else
			{
				modesBase.showInputError(errMsg);
			}
			
			console.debug("Done");
			
		}
	}
	
	
	Connections {
		target: modesBase.answerField
		
		onTextChanged: {
			console.debug("Text changed:", modesBase.answerField.text);
			
		}

		onEditingFinished: {
			console.debug("Editing finished:", modesBase.answerField.text);
		}
	}
	
	/*
	  120, 45
	  m			n	 r
	  120 = 2 * 45 + 30
	  45 = 2 * 30 + 15
	  30 = 2 * 15 + 0
	  gcd = 15
	  */
	
//	GMath.Fraction {
//		width: 40
//		anchors.centerIn: parent
//	}
	
	GMath.Equation {
//		anchors.top: parent.top
//		anchors.left: panel.right
//		anchors.right: modesBase.right
//		anchors.bottom: answerField.top
		anchors.centerIn: parent
		
		equation: "3 + 1/2"
		
	}

	function checkAnswer(frac1, op, frac2, ans) {
		
	}
	
}
