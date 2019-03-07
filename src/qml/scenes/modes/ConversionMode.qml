import QtQuick 2.0

import "../backdrops"
import "../../graphicmath"
import "../../game/singles"

import "../../js/Fraction.js" as JFraction
import "../../js/Math.js" as JMath

ModesBase {
	id: modesBase
	
	difficulties: ["Fraction", "Decimal"]
	readonly property int toFraction: 0
	readonly property int toDecimal: 1
	
	readonly property var parsingError: ({
											 0: "",
											 1: "Program Error: Undefined input passed into `ConversionMode.hasParsingError` function.",
											 2: "Expected numeric value: [0-9].[0-9]"
										 })
	
	modeName: 'Conversion'
	rewardAmount: 2
	unit: "fractons"
	
	
	onDifficultyIndexChanged: {
		if (difficultyIndex === toDecimal)
			setCustomNumpadKeys([7, 8, 9, 4, 5, 6, 1, 2, 3, '.', 0, 'back']);
		else
			setCustomNumpadKeys([7, 8, 9, 4, 5, 6, 1, 2, 3, '/', 0, 'back']);
	}
	
	QtObject {
		id: equationComponents
		property var lhs: new JFraction.Fraction()
		property var rhs: new JFraction.Fraction()
		
		function join() {
			return lhs + ' = ' + rhs;
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
			return lhs + ' = ' + reparseRhs(answerField.text);
		}
	}
	
	Equation {
		id: equation
		anchors.centerIn: drawingArea
		text: hasInputError || answerField.text.length === 0 ? equationComponents.join() : equationComponents.dynamicJoin()
	}
	
	
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
		
		var isCorrect = difficultyIndex === toDecimal ? lhs.equalsValue(rhs) : rhs.equalsValue(lhs);
		console.debug("Question:", equationComponents.join());
		console.debug("Answer:", "'" + lhs + "'", "versus", "User Answer: '" + rhs + "'", ':', isCorrect);
		
		if (isCorrect && difficultyIndex === toFraction)
		{
			if (rhs.d > 1000)
				JGameAchievements.addProgressByName("troublemaker", 1);
		}
		
		return isCorrect;
	}
	
	//	generates a new, random question
	function generateRandomQuestion() {
		
		if (difficultyIndex === toDecimal)
		{
			var denominators = [
						2,
						4,
						5,
						8,
						10
					];
			
			var d = JMath.choose(denominators);
			var n = JMath.randI(0, d);
			
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
}
