import QtQuick 2.0

import "../backdrops"
import "../../game"
import "../../graphicmath"

import "../../js/Fraction.js" as JFraction
import "../../js/Math.js" as JMath

//	TODO : WARNING TRUTH MODE IS BUGGY!

ModesBase {
	id: modesBase
	
	difficulties: ["Easy", "Medium", "Hard"]
	readonly property int easy: 0
	readonly property int medium: 1
	readonly property int hard: 2
	
	readonly property var parsingError: ({
											 0: "",
											 1: "Program Error: Undefined input passed into `TruthMode.hasParsingError` function.",
											 2: "Expected one character: 'T' or 'F'"
										 })
	
	modeName: 'Truth'
	rewardAmount: [2, 3, 5][difficultyIndex]
	unit: "fractons"
	
	Component.onCompleted: {
		numberPad.visible = false;
	}
	
	
	QtObject {
		id: equationComponents
		property var lhs: new JFraction.Fraction()
		property var rhs: new JFraction.Fraction()
		
		property string op: '='
		
		//	different from other modes, correct answer is calculated when question is generated
		property bool isTrue: true
		
		function join() {
			return lhs + ' ' + (op === "<" ? "\<" : op) + ' ' + rhs;
		}
	}
	
	Equation {
		id: equation
		anchors.centerIn: drawingArea
		text: equationComponents.join()
	}
	
	TruthPad {
		id: truthPad
		width: 80; height: 100
		anchors {
			right: drawingArea.right
			bottom: drawingArea.bottom
			margins: 5
		}
		
		visible: numberPadVisible
		
		onKeyPressed: /*(key: string)*/ {
			if (key === 'back')
			{
				if (answerField.text.length > 0)
					answerField.text = answerField.text.substring(0, answerField.text.length - 1);
				
				return;
			}
			
			answerField.text += key;
		}
	}
	
	function hasParsingError(text) {
		//	check undefined input
		if (text === undefined)
			return 1;
		
		//	check empty string
		if (text.length === 0)
			return 0;
		
		//	check that length is 1
		if (text.length !== 1)
			return 2;
		
		var head = text[0];
		
		//	check if first letter was T or F
		if (!'TF'.includes(head.toUpperCase()))
			return 2;
		
		//	all good
		return 0;
	}
	
	function checkInput(text) {
		if (text.length === 0)
		{
			rejectInput("Expected input.")
			return false;
		}
		
		var errCode = hasParsingError(text);
		if (errCode)
		{
			rejectInput(parsingError[errCode]);
			return false;
		}
		
		acceptInput();
		return true;
	}
	
	//	ans: JFraction.Fraction
	//	return: bool
	function checkAnswer(text) {
		var res = false;		
		
		if (text[0].toUpperCase() === 'T' && equationComponents.isTrue)
			res = true;
		
		if (text[0].toUpperCase() === 'F' && !equationComponents.isTrue)
			res = true;
		
		
		console.debug("Question:", equationComponents.join());
		console.debug("Answer:", equationComponents.isTrue, "versus", text[0].toUpperCase() === 'T');
		
		return res;
	}
	
	function generateEqualityRelation(baseMin, baseMax, absoluteMax, answer) {
		var leftN, leftD, rightN, rightD;
		
		//	choose a left fraction
		leftD = JMath.randI(baseMin, baseMax);
		leftN = JMath.randI(1, difficultyIndex === hard ? absoluteMax : leftD-1);
		
		if (answer === true)
		{
			//	get the maximum factor
			var maxFactor = Math.floor(absoluteMax / leftD);
			
			//	get the gcd factors
			var leftGcdFactors = JMath.factors(JMath.gcd(leftN, leftD));
			
			//	choose a denominator for the factor; remove the gcd factor 1 if possible
			var factorD = JMath.choose(leftGcdFactors.slice(leftGcdFactors.length > 1));
			
			//	choose a numerator for the factor; it shouldn't be the same as factorD
			var factorN = JMath.choose(JMath.range(1, factorD).concat(JMath.range(factorD+1, maxFactor+1)));
			
			//	set the factor and multiply the lhs onto the right
			var factor = factorN / factorD;
			
			rightN = leftN * factor;
			rightD = leftD * factor;
		}
		else	//	answer === false
		{
			//	special case for if leftD is baseMin is 2
			if (leftD === 2 && baseMin === 2)
				rightD = JMath.randI(3, absoluteMax);
			else
				rightD = JMath.randI(baseMin, absoluteMax);
			
			if (difficultyIndex === easy || difficultyIndex === medium)
			{
				//	set the right numerator
				if (leftD === rightD)
					//	... to anything but leftN
					rightN = JMath.choose(JMath.range(1, leftN).concat(JMath.range(leftN+1, rightD)));
				else if (JMath.gcd(leftD, rightD) > 1)
					//	... to anything but the calculated factor
					rightN = JMath.choose(JMath.range(1, leftN*rightD/leftD).concat(JMath.range(Math.floor(leftN*rightD/leftD)+1, rightD)));
				else
					//	... to anything
					rightN = JMath.randI(1, rightD-1);
			}
			else if (difficultyIndex === hard)
			{
				//	in hard mode, numerators are not bounded by the denominators
				
				if (leftD === rightD)
					rightN = JMath.choose(JMath.range(1, leftN).concat(JMath.range(leftN+1, absoluteMax)));
				else if (JMath.gcd(leftD, rightD) > 1)
					rightN = JMath.choose(JMath.range(1, leftN*rightD/leftD).concat(JMath.range(Math.floor(leftN*rightD/leftD)+1, absoluteMax)));
				else
					rightN = JMath.randI(1, absoluteMax);
			}
			
			
		}
		
		return { left: new JFraction.Fraction(leftN, leftD), right: new JFraction.Fraction(rightN, rightD) };
	}
	
	function generateRandomQuestion() {
		
		//	generate lhs fraction
		
		var relationalOperators = [
					"=",
					"=≠",
					"=≠<>",
//					">",
				][difficultyIndex];
		
		var operator = JMath.choose(relationalOperators);
		
		var answer = JMath.coin();
//		var answer = false;
//		var answer = true;
		
		var leftN, leftD, rightN, rightD;
		
//		var absoluteMax, baseMin, baseMax;
//		var factor, maxFactor, factorN, factorD, leftGcdFactors;	//	TODO refactor
		
		var swap = false;
		var relation;
		
//		var generateEqualityRelation = 
		
		
		//	TODO refactor algo into function with params baseMin, baseMax, absoluteMax, operator, answer
		if (difficultyIndex === easy)
		{
//			//	easy mode
//			baseMin = 2;
//			baseMax = 8;
//			absoluteMax = 16;
			
//			//	choose a left fraction
//			leftD = JMath.randI(baseMin, baseMax);
//			leftN = JMath.randI(1, leftD-1);
			
//			if (answer === true)
//			{
//				//	get the maximum factor
//				maxFactor = Math.floor(absoluteMax / leftD);
				
//				//	get the gcd factors
//				leftGcdFactors = JMath.factors(JMath.gcd(leftN, leftD));
				
//				//	choose a denominator for the factor; remove the gcd factor 1 if possible
//				factorD = JMath.choose(leftGcdFactors.slice(leftGcdFactors.length > 1));
				
//				//	choose a numerator for the factor; it shouldn't be the same as factorD
//				factorN = JMath.choose(JMath.range(1, factorD).concat(JMath.range(factorD+1, maxFactor+1)));
				
//				//	set the factor and multiply the lhs onto the right
//				factor = factorN / factorD;
				
//				rightN = leftN * factor;
//				rightD = leftD * factor;
//			}
//			else	//	answer === false
//			{
////				rightD = JMath.randI(2, 12);
				
//				//	special case for if leftD is baseMin is 2
//				if (leftD === 2 && baseMin === 2)
//					rightD = JMath.randI(3, absoluteMax);
//				else
//					rightD = JMath.randI(baseMin, absoluteMax);
				
//				//	set the right numerator
//				if (leftD === rightD)
//					//	... to anything but leftN
//					rightN = JMath.choose(JMath.range(1, leftN).concat(JMath.range(leftN+1, rightD)));
//				else if (JMath.gcd(leftD, rightD) > 1)
//					//	... to anything but the calculated factor
//					rightN = JMath.choose(JMath.range(1, leftN*rightD/leftD).concat(JMath.range(Math.floor(leftN*rightD/leftD)+1, rightD)));
//				else
//					//	... to anything
//					rightN = JMath.randI(1, rightD-1);
//			}
			
			relation = generateEqualityRelation(2, 6, 12, answer);
			
			//	chance to swap
			swap = JMath.coin();
//			equationComponents.lhs = swap ? new JFraction.Fraction(leftN, leftD) : new JFraction.Fraction(rightN, rightD);
//			equationComponents.rhs = swap ? new JFraction.Fraction(rightN, rightD) : new JFraction.Fraction(leftN, leftD);
			equationComponents.lhs = swap ? relation.left : relation.right;
			equationComponents.rhs = swap ? relation.right : relation.left;
			
			equationComponents.op = operator;
			equationComponents.isTrue = answer;
		}
		else if (difficultyIndex === medium)
		{
			relation = generateEqualityRelation(2, 8, 16, answer);
			
			//	chance to swap
			swap = JMath.coin();
			equationComponents.lhs = swap ? relation.left : relation.right;
			equationComponents.rhs = swap ? relation.right : relation.left;
			
			equationComponents.op = operator;
			
			if (operator === "=")
				equationComponents.isTrue = answer;
			else if (operator === "≠")
				equationComponents.isTrue = !answer;
		}
		else if (difficultyIndex === hard)
		{
			//	medium mode
//			baseMin = 2;
//			baseMax = 16;
//			absoluteMax = 40;
			
			
			if (operator === "=" || operator === "≠")
			{
				relation = generateEqualityRelation(2, 8, 16, answer);
				
				equationComponents.lhs = swap ? relation.left : relation.right;
				equationComponents.rhs = swap ? relation.right : relation.left;
				
			}
			else if (operator === "<" || operator === ">")
			{
				var high = 20;
				var bound;
				if (answer === true)
				{
					//	assume operator is <
					//	generate fraction for bigger number first
					rightN = JMath.randI(2, high);
					rightD = JMath.randI(2, high);
					
					leftD = JMath.randI(2, Math.min(high, high * rightD/rightN));
					bound = Math.ceil(rightN * leftD / rightD) - 1;
					leftN = JMath.randI(bound ? 1 : 0, bound);
				}
				else
				{
					rightN = JMath.randI(2, high);
					rightD = JMath.randI(2, high);
					
					leftD = JMath.randI(2, Math.min(high, high * rightD/rightN));
					bound = Math.ceil(rightN * leftD / rightD);
					leftN = JMath.randI(bound, high);
				}
				
				var left = new JFraction.Fraction(leftN, leftD);
				var right = new JFraction.Fraction(rightN, rightD);
				
				if (operator === ">")
					left.swap(right);
				
				equationComponents.lhs = left;
				equationComponents.rhs = right;
			}
			
			equationComponents.op = operator;
			
			if (operator === "=")
				equationComponents.isTrue = answer;
			else if (operator === "≠")
				equationComponents.isTrue = !answer;
			else if (operator === "<")
				equationComponents.isTrue = answer;
			else if (operator === ">")
				equationComponents.isTrue = answer;
			
		}
		
		//	TODO upgrade this generateRandomQuestion() to encompass hard difficulty
		//	
	}
	
	//	encodes the current question's state
	function getQuestionState() {
		return equationComponents.join();
	}
	
	//	decodes the state provided
	function parseQuestionState(state) {
		var expressions;
		
		var i, ops = "=≠<>≤≥";
		for (i in ops)
		{
			if (state.indexOf(ops[i]) !== -1)
			{
				expressions = state.split(ops[i]);
				break;
			}
		}
		
		expressions = [expressions[0].trim(), expressions[1].trim()];
		
		equationComponents.lhs = JFraction.parse(expressions[0]);
		equationComponents.op = ops[i];
		equationComponents.rhs = JFraction.parse(expressions[1]);
		
	}
}
