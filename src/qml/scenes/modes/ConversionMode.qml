import QtQuick 2.0

import "../backdrops"
import "../../common"
import "../../graphicmath"
import "../../game/singles"

import "../../js/Fraction.js" as JFraction
import "../../js/Math.js" as JMath

ModesBase {
	id: modesBase
	
	readonly property int toDecimal: 0
	readonly property int toFraction: 1
	readonly property var parsingError: ({
											 0: "",
											 1: "Program Error: Undefined input passed into `ConversionMode.hasParsingError` function.",
											 2: "Expected numeric value: [0-9].[0-9]"
										 })
	
	//	checks if text has a parsing error
	function hasParsingError(text) {
		
		if (difficultyIndex === toDecimal)
		{
			if (text === undefined)
				return 1;
			
			if (text.length === 0)
				return 0;
			
			if (isNaN(text))
				return 2;
			
			return 0;
		}
		else if (difficultyIndex === toFraction)
		{
			var errCode = JFraction.isParsibleWithError(text);
			return errCode;
		}
		
	}
	
	//	checks text against input validation
	function checkInput(text) {
		if (text.length === 0)
		{
			rejectInput("Expected input.")
			return false;
		}
		
		var errCode = hasParsingError(text);
		if (errCode)
		{
			rejectInput(difficultyIndex === toDecimal ? parsingError[errCode] : JFraction.ParsingError[errCode]);
			return false;
		}
		
		acceptInput();
		return true;
	}
	
	//	checks the answer provided by text
	function checkAnswer(text) {
		
		var lhs = equationComponents.lhs;
		var rhs = equationComponents.reparseRhs(text);
		
		var isCorrect = difficultyIndex === toDecimal ? equationComponents.isApprox ? lhs.approximatesTo(rhs)
																					: lhs.equalsValue(rhs)
													  : rhs.equalsValue(lhs);
		
		console.debug("Question:", equationComponents.join());
		console.debug("Answer:", "'" + lhs + "'", "versus", "User Answer: '" + rhs + "'", ':', isCorrect);
		
		if (isCorrect && difficultyIndex === toFraction)
		{
			if (rhs.d > 1000)
				JGameAchievements.addProgressByName("troublemaker", 1);
		}
		
		return isCorrect;
	}
	
	function getCorrectAnswer() {
		var lhs = equationComponents.lhs;
		if (difficultyIndex === toDecimal)
		{
			if (equationComponents.isApprox)
				return Math.round(lhs.value() * 1000) / 1000;
			
			return lhs.value();
		}
		
		var lhs_s = '' + lhs;
		var places = lhs_s.length - 2;
		return new JFraction.Fraction(lhs * Math.pow(10, places), Math.pow(10, places)).simplified().toString();
	}
	
	//	generates a new, random question
	function generateRandomQuestion() {
		
		if (difficultyIndex === toDecimal)
		{
			var d = JMath.randI(2, 10);
			var n = JMath.randI(1, d-1);
			
			equationComponents.isApprox = !("2,4,5,8,10".includes(d)) && !(d === 6 && n === 3);
			
			equationComponents.lhs = new JFraction.Fraction(n, d);
			equationComponents.rhs = '?';
		}
		else if (difficultyIndex === toFraction)
		{
			var values = [
						0.1,
						0.125,
						0.2,
						0.25,
						0.375,
						0.4,
						0.5,
						0.6,
						0.625,
						0.7,
						0.75,
						0.8,
						0.875,
						0.9,
					];
			
			equationComponents.lhs = JMath.choose(values);
			equationComponents.rhs = new JFraction.Fraction('?', '?');
			
			equationComponents.isApprox = false;
		}
		
	}
	
	//	encodes the current question's state
	function getQuestionState() {
		return equationComponents.join();
	}
	
	//	decodes the state provided
	function parseQuestionState(state) {
		var expressions = state.split('=');
		expressions = [expressions[0].trim(), expressions[1].trim()];
		
		if (difficultyIndex === toDecimal)
		{
			equationComponents.lhs = JFraction.parse(expressions[0]);
			equationComponents.rhs = expressions[1];
		}
		else if (difficultyIndex === toFraction)
		{
			equationComponents.lhs = Number(expressions[0]);
			equationComponents.rhs = JFraction.parse(expressions[1]);
		}
	}
	
	//	OBJECT PROPERTIES
	difficulties: ["Decimal", "Fraction"]
	
	modeName: 'Conversion'
	rewardAmount: [2, 1][difficultyIndex]
	unit: "fractons"
	
	numberPad.keys: difficultyIndex === toDecimal ? [7, 8, 9, 4, 5, 6, 1, 2, 3, '.', 0, 'back'] : [7, 8, 9, 4, 5, 6, 1, 2, 3, '/', 0, 'back']
	
	help: Item {
		Column {
			width: parent.width
			spacing: 20
			
			TextBase { text: "Conversion Mode" }
			ParagraphText { text: "In this mode, you gain ƒractons by converting between decimals and fractions." }
			TextBase { text: "Example:" }
			Equation {
				anchors.horizontalCenter: parent.horizontalCenter
				text: difficultyIndex === toDecimal ? "1/3 ≈ ?" : "0.25 = ?/?"
			}
			TextBase { text: "Answer: " + (difficultyIndex === toDecimal ? "0.333" : "1/4") }
			ParagraphText {
				text: "For approximations (≈), round the answer to 2 or 3 decimal places."
				font.pointSize: 8
				visible: difficultyIndex === toDecimal
			}
		}
	}
	
	centerpiece: Equation {
		id: equation
		text: hasInputError || userInput().length === 0 ? equationComponents.join() : equationComponents.dynamicJoin()
	}
	
	QtObject {
		id: equationComponents
		property var lhs: new JFraction.Fraction()
		property var rhs: new JFraction.Fraction()
		property bool isApprox: false
		
		function join() {
			return lhs + (isApprox ? ' ≈ ' : ' = ') + rhs;
		}
		
		//	substitutes arguments in place of question marks, no error checking is done
		//	input: JFraction.Fraction.string
		//	return: JFraction.Fraction
		function reparseRhs(input) {
			if (difficultyIndex === toDecimal)
			{
				return Number(input);
			}
			else if (difficultyIndex === toFraction)
			{
				//	parse input as fraction
				var frac = JFraction.parse(input);
				
				return frac;
			}
		}
		
		//	joins with input in rhs
		function dynamicJoin() {
			return lhs + (isApprox ? ' ≈ ' : ' = ') + reparseRhs(userInput());
		}
	}
	
}
