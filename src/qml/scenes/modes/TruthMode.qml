import QtQuick 2.0

import "../backdrops"
import "../../common"
import "../../graphicmath"

import "../../js/Fraction.js" as JFraction
import "../../js/Math.js" as JMath

ModesBase {
	id: modesBase
	
	//	== PROPERTY DECLARATIONS ==
	
	readonly property int easy: 0
	readonly property int medium: 1
	readonly property int hard: 2
	readonly property var parsingError: ({
											 0: "",
											 1: "Program Error: Undefined input passed into `TruthMode.hasParsingError` function.",
											 2: "Expected one character: 'T' or 'F'"
										 })
	
	//	== JS FUNCTIONS ==
	
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
	
	function getCorrectAnswer() {
		return equationComponents.isTrue ? "T" : "F";
	}
	
	
	function generateEqualityRelation(baseMin, baseMax, absoluteMax, answer) {
		var n_l, d_l, n_r, d_r;
		
		//	choose a left fraction
		d_l = JMath.randI(baseMin, baseMax);
		n_l = JMath.randI(1, difficultyIndex === hard ? absoluteMax : d_l-1);
		
		if (answer === true)
		{
			//	get the maximum factor
			var maxFactor = Math.floor(absoluteMax / d_l);
			
			//	get the gcd factors
			var leftGcdFactors = JMath.factors(JMath.gcd(n_l, d_l));
			
			//	choose a denominator for the factor; remove the gcd factor 1 if possible
			var factorD = JMath.choose(leftGcdFactors.slice(leftGcdFactors.length > 1));
			
			//	choose a numerator for the factor; it shouldn't be the same as factorD
			var factorN = JMath.choose(JMath.range(1, factorD).concat(JMath.range(factorD+1, maxFactor+1)));
			
			//	set the factor and multiply the lhs onto the right
			var factor = factorN / factorD;
			
			n_r = n_l * factor;
			d_r = d_l * factor;
		}
		else	//	answer === false
		{
			//	special case for if leftD is baseMin is 2
			d_r = JMath.randI(baseMin === 2 ? 3 : baseMin, absoluteMax);
			
			if (difficultyIndex === easy || difficultyIndex === medium)
			{
				//	set the right numerator
				if (d_l === d_r)
					//	... to anything but leftN
					n_r = JMath.choose(JMath.range(1, n_l).concat(JMath.range(n_l+1, d_r)));
				else if (JMath.gcd(d_l, d_r) > 1)
					//	... to anything but the calculated factor
					n_r = JMath.choose(JMath.range(1, d_r*n_l/d_l).concat(JMath.range(Math.floor(d_r*n_l/d_l)+1, d_r)));
				else
					//	... to anything
					n_r = JMath.randI(1, d_r-1);
			}
			else if (difficultyIndex === hard)
			{
				//	in hard mode, numerators are not bounded by the denominators
				
				if (d_l === d_r)
					n_r = JMath.choose(JMath.range(1, n_l).concat(JMath.range(n_l+1, absoluteMax)));
				else if (JMath.gcd(d_l, d_r) > 1)
					n_r = JMath.choose(JMath.range(1, n_l*d_r/d_l).concat(JMath.range(Math.floor(n_l*d_r/d_l)+1, absoluteMax)));
				else
					n_r = JMath.randI(1, absoluteMax);
			}
			
			
		}
		
		return { left: new JFraction.Fraction(n_l, d_l), right: new JFraction.Fraction(n_r, d_r) };
	}
	
	function generateRandomQuestion() {
		
		//	choose a set of relational operators based on the difficulty
		var relationalOperators = [
					"=",
					"=≠",
					"=≠<>",
				][difficultyIndex];
		
		//	choose one operator
		var operator = JMath.choose(relationalOperators);
		
		//	preset an answer (we want the chance to be fair that the answer is either correct/incorrect)
		var answer = JMath.coin();
		
		//	buffer variables
		var relation, swap = false;
		
		if (difficultyIndex === easy)
		{
			//	easy mode
			relation = generateEqualityRelation(2, 6, 12, answer);
			
			//	chance to swap
			swap = JMath.coin();
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
			//	hard mode (allows improper fractions)
			
			if (operator === "=" || operator === "≠")
			{
				relation = generateEqualityRelation(2, 8, 16, answer);
				
				equationComponents.lhs = swap ? relation.left : relation.right;
				equationComponents.rhs = swap ? relation.right : relation.left;
			}
			else if (operator === "<" || operator === ">")
			{
				var n_l, d_l, n_r, d_r;
				
				var high = 20;
				var bound;
				if (answer === true)
				{
					//	assume operator is <
					//	generate fraction for bigger number first
					n_r = JMath.randI(2, high);
					d_r = JMath.randI(2, high);
					
					//	upper bound for d_l should be no higher than `high`, and take into account the bound (d_l*n_r/d_r < high)
					d_l = JMath.randI(2, Math.min(high, high * d_r/n_r));
					
					//	temporary upper bound for n_l
					bound = Math.ceil(d_l * n_r/d_r) - 1;
					
					//	n_l < d_l * n_r/d_r
					n_l = JMath.randI(bound ? 1 : 0, bound);
				}
				else
				{
					n_r = JMath.randI(2, high);
					d_r = JMath.randI(2, high);
					
					d_l = JMath.randI(2, Math.min(high, high * d_r/n_r));
					bound = Math.ceil(d_l * n_r/d_r);
					
					//	n_l ≥ d_l * n_r/d_r
					n_l = JMath.randI(bound, high);
				}
				
				var left = new JFraction.Fraction(n_l, d_l);
				var right = new JFraction.Fraction(n_r, d_r);
				
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
	
	
	//	== OBJECT PROPERTIES ==
	
	difficulties: ["Easy", "Medium", "Hard"]
	modeName: 'Truth'
	rewardAmount: [2, 3, 5][difficultyIndex]
	unit: "fractons"
	numberPad.keys: ["T", "F", "back"]
	
	help: Item {
		Column {
			width: parent.width
			spacing: 20
			
			TextBase { text: "Truth Mode" }
			ParagraphText { text: "In this mode, you gain ƒractons by correctly discerning true equations from false ones." }
			TextBase { text: "Example:" }
			Equation { anchors.horizontalCenter: parent.horizontalCenter; text: "1/2 = 0/10" }
			TextBase { text: "Answer: F" }
		}
	}
	
	centerpiece: Equation {
		id: equation
		text: equationComponents.join()
	}
	
	Component.onCompleted: {
		numberPad.height /= 3;
	}
	
	
	//	== CHILD OBJECTS ==
	
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
	
	
	
	
}
