import QtQuick 2.0

import "../backdrops"
import "../../game"
import "../../graphicmath"

import "../../js/Fraction.js" as JFraction
import "../../js/Math.js" as JMath

//	TODO : WARNING TRUTH MODE IS BUGGY!

ModesBase {
	id: modesBase
	
	difficulties: ["Easy", "Medium", "Hard", "Sensei"]
	readonly property int easy: 0
	readonly property int medium: 1
	readonly property int hard: 2
	readonly property int sensei: 3
	
	readonly property var parsingError: ({
											 0: "",
											 1: "Program Error: Undefined input passed into `TruthMode.hasParsingError` function.",
											 2: "Expected one character: 'T' or 'F'"
										 })
	
	modeName: 'Truth'
	rewardAmount: [3, 5, 7, 10][difficultyIndex]
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
			return lhs + ' ' + op + ' ' + rhs;
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
		
		onKeyPressed: /*params: {string key}*/ {
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
		
		var head = text[0].toUpperCase();
		
		//	check if first letter was T or F
		if (!'TF'.includes(head))
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
	
	function generateRandomQuestion() {
		
		//	generate lhs fraction
		
		var choiceArray = [
					[1],
					[1, 1, 1, 1, 1, 1, 1, 2],	//	one: 7 in 8; two: 1 in 8
					[1, 1, 1, 1, 2],	//	one: 4 in 5; two: 1 in 5
					[1, 2]	//	one: 1 in 2; two: 1 in 2
				][difficultyIndex];
		
		var lhsNumExpressions = JMath.choose(choiceArray);
		var rhsNumExpressions = JMath.choose(choiceArray);
		
		var lhsNumOperands = lhsNumExpressions - 1;
		var rhsNumOperands = rhsNumExpressions - 1;
		
		
		var equityOperandArray = [
					"=",
					"=≠",
					"=≠<>",
					"=≠<>≤≥"
				][difficultyIndex];
		
		var centralOperand = JMath.choose(equityOperandArray);
		
		
		var operandArray = [
					"",
					"+-",
					"+-*",
					"+-*/"
				][difficultyIndex];
		
		var forceTrue = JMath.coin();	//	determine with 50% chance to force the question into a True answer or a False answer
		var forceFalse = !forceTrue;
		
		var i;
		for (i = 0; i < lhsNumExpressions; i++)
		{
			
		}
		
		var leftN, leftD, rightN, rightD;
		var temp;
		
		if (difficultyIndex === easy)
		{
			//	easy mode: 
			//	 + only one term per side
			//	 + no binary operators
			//	 + only = operandi
			
			leftD = JMath.randI(2, 10);
			
			
			if (forceTrue)
			{
				//	then make this a simplification exercise
				
//				leftN = JMath.randI(0, leftD);
				leftN = JMath.randI(1, leftD);
				
//				if (leftN === 0)
//				{
//					rightN = 0;
//					rightD = JMath.randI(2, 10);
//				}
//				else 
				if (new JFraction.Fraction(leftN, leftD).isSimplified() === false && JMath.coin())
				{
					//	use simplified
					rightN = leftN / JMath.gcd(leftN, leftD)
					rightD = leftD / JMath.gcd(leftN, leftD)
				}
				else
				{
					rightD = leftD * JMath.randI(2, 3);
					rightN = leftN * (rightD / leftD);
				}
				
			}
			else	//	forceFalse
			{
				//	keep the denominator same (or different :P)
				
				leftN = JMath.randI(1, leftD);
				
				rightD = JMath.randI(0, 12);
				
				//	check if true version of rightN is integer
				temp = new JFraction.Fraction(leftN*rightD, leftD);
				if (temp.isInteger())
				{
					temp = temp.toInteger();
					
					//	choose from a range without temp
					rightN = JMath.choose(JMath.range(0, temp).concat(JMath.range(temp + 1, rightD)));
				}
				else
					rightN = JMath.randI(0, rightD);	//	choose any
				
//				//	offset the correct answer by a number
//				temp = JMath.choose([-3, -2, -1, 1, 2, 3]);
//				if (rightD === leftD)
//				{
//					//	offset the denominator
//					rightN = leftN + temp;
//					if (rightN <= 0) rightN = leftN + 1;
//				}
//				else
//				{
//					rightN = leftN * Math.floor(rightD / leftD) + temp;
//					if (rightN <= 0) rightN = leftN * Math.floor(rightD / leftD) + 1;
//				}
				
			}
			
			equationComponents.lhs = new JFraction.Fraction(leftN, leftD).toString();
			equationComponents.rhs = new JFraction.Fraction(rightN, rightD).toString();
			equationComponents.op = centralOperand;
			equationComponents.isTrue = forceTrue;
		}
		else if (difficultyIndex === medium)
		{
			equationComponents.lhs = '?/?';
			equationComponents.rhs = '?/?';
			equationComponents.op = centralOperand;
			equationComponents.isTrue = forceTrue;
		}
		else if (difficultyIndex === hard)
		{
			equationComponents.lhs = '?/?';
			equationComponents.rhs = '?/?';
			equationComponents.op = centralOperand;
			equationComponents.isTrue = forceTrue;
		}
		else if (difficultyIndex === sensei)
		{
			equationComponents.lhs = '?/?';
			equationComponents.rhs = '?/?';
			equationComponents.op = centralOperand;
			equationComponents.isTrue = forceTrue;
		}
		
		
		//	TODO upgrade this generateRandomQuestion() to encompass medium, hard, and sensei difficulties
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
