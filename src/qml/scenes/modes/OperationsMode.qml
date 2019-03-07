import QtQuick 2.0

import "../backdrops"
import "../../common"
import "../../graphicmath/"
import "../../game/singles"

import "../../js/Fraction.js" as JFraction
import "../../js/Math.js" as JMath

//	todo implement velocity

ModesBase {
	id: modesBase
	
	property int operation: addition
	readonly property int addition: 0
	readonly property int subtraction: 1
	readonly property int multiplication: 2
	readonly property int division: 3
	
	difficulties: ["Easy", "Medium", "Hard"]
	readonly property int easy: 0
	readonly property int medium: 1
	readonly property int hard: 2
	
	modeName: 'Operations'
	rewardAmount: [1, 3, 5][difficultyIndex]
	unit: "fractons"
	
	
	QtObject {
		id: equationComponents
		property var lhsFractionA: new JFraction.Fraction()
		property var lhsFractionB: new JFraction.Fraction()
		
		//	+, -, *, or ÷ //	readonly
		readonly property string op: {
			//	update operation
			if (operation === addition)
				return JMath.operations['add'];
			else if (operation === subtraction)
				return JMath.operations['sub'];
			else if (operation === multiplication)
				return JMath.operations['mul'];
			else if (operation === division)
				return JMath.operations['div'];
			
			return '?';
		}
		
		property var rhsFraction: new JFraction.Fraction('?')
		
		//	normal join
		function join() {
			return lhsFractionA + ' ' + op + ' ' + lhsFractionB + ' = ' + rhsFraction;
		}
		
		//	substitutes arguments in place of question marks, no error checking is done
		//	input: JFraction.Fraction.string
		//	return: JFraction.Fraction
		function reparseRhs(input) {
			
			//	parse input as fraction
			var frac = JFraction.parse(input);
			
			//	in medium/hard mode, both numerator and denominator are ?
			//	so we just return the entire fraction input
			if (difficultyIndex !== easy)
				return frac;
			
			//	fractional inputs should be rejected since there is only one "?" 
			var token = (frac.isInteger() ? frac.toInteger() : "??");
			
			//	convert rhs fraction to a string so that we can find & replace "?"
			var rhsFrac_s = rhsFraction.toString();
			
			//	find "?" and...
			var i = rhsFrac_s.indexOf('?');
			
			//	...	replace
			rhsFrac_s = rhsFrac_s.substring(0, i) + token + rhsFrac_s.substring(i + 1);
			
			//	return as fraction
			return JFraction.parse(rhsFrac_s);
		}
		
		//	joins with input in rhs
		function dynamicJoin() {
			return lhsFractionA + ' ' + op + ' ' + lhsFractionB + ' = ' + reparseRhs(answerField.text);
		}
	}
	
	//	displays the equation as text
	Equation {
		id: equation
		anchors.centerIn: drawingArea
		text: hasInputError || answerField.text.length === 0 ? equationComponents.join() : equationComponents.dynamicJoin()
	}
	
	
	function hasParsingError(text) {
		var errCode = JFraction.isParsibleWithError(text);
		return errCode;
	}
	
	//	provides input validation for a given input
	//	text: string
	//	return: bool
	function checkInput(text) {
		if (text.length === 0)
		{
			rejectInput("Expected input.")
			return false;
		}
		
		var errCode = hasParsingError(text);
		if (errCode)
		{
			rejectInput(JFraction.ParsingError[errCode]);
			return false;
		}
		
		acceptInput();
		return true;
	}
	
	//	receives an answer input as a fraction and checks the values
	//	text: string
	//	return: bool
	function checkAnswer(text) {
		var ans = JFraction.parse(text);
		
		
		//	parse the rhs as a JFraction
		var rhs = equationComponents.reparseRhs(ans.toString());
		
		var lhs = (operation === addition ? equationComponents.lhsFractionA.add(equationComponents.lhsFractionB) :
					operation === subtraction ? equationComponents.lhsFractionA.sub(equationComponents.lhsFractionB) : 
					operation === multiplication ? equationComponents.lhsFractionA.mul(equationComponents.lhsFractionB) :
					operation === division ? equationComponents.lhsFractionA.div(equationComponents.lhsFractionB) :
											 equationComponents.lhsFractionA);
		
		var isCorrect = lhs.equals(rhs.toNumericFraction());
		console.debug("Question:", equationComponents.join());
		console.debug("Answer:", "'" + lhs + "'", "(or", lhs.simplified(), ")", "versus", "'" + rhs + "'", ':', isCorrect);
		
		if (isCorrect)
		{
			if (rhs.d > 1000)
				JGameAchievements.addProgressByName("troublemaker", 1);
		}
		
		return isCorrect;
	}
	
	//	updates equationComponents with new values ('new' is not guaranteed)
	//	return: void
	function generateRandomQuestion() {
		
		var n1, n2, d, d1, d2;
		n1 = n2 = d = d1 = d2 = 0;
		
		//	generate fraction components
		if (difficultyIndex === easy)
		{
			//	easy difficulty:
			//	 + proper fractions only
			//	 + same denominator
			//	 + only addition and subtraction
			//	 + numerator answer only
			//	 + denominators up to 20
			
			//	generate appropriate result, then derive question
			operation = JMath.randI(addition, subtraction);
			
			d = JMath.randI(3, 20);
			if (operation === addition)
			{
				n1 = JMath.randI(1, d - 2);
				n2 = JMath.randI(1, d - n1);
			}
			else if (operation === subtraction)
			{
				n1 = JMath.randI(2, d);
				n2 = JMath.randI(1, n1);
			}
			
			equationComponents.lhsFractionA = new JFraction.Fraction(n1, d);
			equationComponents.lhsFractionB = new JFraction.Fraction(n2, d);
			equationComponents.rhsFraction = new JFraction.Fraction('?', d);
		}
		else if (difficultyIndex === medium)
		{
			//	medium difficulty:
			//	 + proper and improper fractions
			//	 + both like and unlike denominators
			//	 + only multiplication and division
			//	 + both numerator and denominator answer
			//	 + denominators up to 10
			
			operation = JMath.randI(multiplication, division);
			
			d1 = JMath.randI(3, 10);
			
			if (operation === multiplication)
			{
				d2 = JMath.randI(3, 10);
				
				n1 = JMath.randI(1, d1);
				n2 = JMath.randI(1, d2);
			}
			else if (operation === division)
			{
				n2 = JMath.randI(1, 10);
				
				n1 = JMath.randI(1, d1);
				
				//	0			≤  n1*d2			≤	n2*d1
				//	0			≤	d2				≤	n2*d1/n1
				d2 = JMath.randI(0, n2*d1/n1);
			}
			
			equationComponents.lhsFractionA = new JFraction.Fraction(n1, d1);
			equationComponents.lhsFractionB = new JFraction.Fraction(n2, d2);
			equationComponents.rhsFraction = new JFraction.Fraction('?', '?');
		}
		else if (difficultyIndex === hard)
		{
			//	hard difficulty:
			//	 + both proper and improper fractions
			//	 + strictly unlike denominators
			//	 + all operations
			//	 + both numerator and denominator answer
			//	 + denominators up to 12
			
			operation = JMath.randI(addition, division);
			
			d1 = JMath.randI(3, 12);
			d2 = JMath.randI(3, 12);
			
			if (operation === addition)
			{
				n1 = JMath.randI(1, d1 - 2);
				
				//	this is an inequality formula for generating proper fractions
				//		1			<   n1*d2 + n2*d1	<	d1*d2
				//	  1 - n1*d2		<	n2*d1			< d1*d2 - n1*d2
				//	(1 - n1*d2)/d1	<	n2				< (d1 - n1)*d2/d1
				//		0			<	n2				<	(d1 - n1)*d2/d1
				//	n2 = JMath.randI(0, Math.floor(d2 - d2*n1/d1));
				
				n2 = JMath.randI(1, d2);
			}
			else if (operation === subtraction)
			{
				n1 = JMath.randI(1, d1);
				
				//	this is an inequality formula for generating proper fractions
				//		1			<   n1*d2 - n2*d1	<	d1*d2
				//	  1 - n1*d2		<	-n2*d1			< d1*d2 - n1*d2
				//	(n1*d2 - 1)/d1	>	n2				> (n1 - d1)*d2/d1
				//	(n1*d2 - 1)/d1	>	n2				> 0
				n2 = JMath.randI(0, Math.floor(d2*n1/d1 - 1/d1));
				
//				n2 = JMath.randI(1, d2);	//	dangerous: we don't want negatives
			}
			else if (operation === multiplication)
			{
				n1 = JMath.randI(1, d1);
				n2 = JMath.randI(1, d2);
			}
			else if (operation === division)
			{
				n1 = JMath.randI(1, d1);
				n2 = JMath.randI(1, d2);
			}
			
			
			equationComponents.lhsFractionA = new JFraction.Fraction(n1, d1);
			equationComponents.lhsFractionB = new JFraction.Fraction(n2, d2);
			equationComponents.rhsFraction = new JFraction.Fraction('?', '?');
		}
	}
	
	//	encodes the current question's state
	function getQuestionState() {
	    return equationComponents.join();
	}
	
	//	decodes the state provided
	function parseQuestionState(state) {
		var expressions = state.split('=');
		
		var ops = { buffer: "=" };
		ops[addition] = JMath.operations.add;
		ops[subtraction] = JMath.operations.sub;
		ops[multiplication] = JMath.operations.mul;
		
		var i, index;
		for (i in ops)
		{
			index = expressions[0].indexOf(ops[i]);
			if (index !== -1)	//	found a match
				break;
		}
		var op, lhs;
		if (index === -1)	//	not found: division
		{
			op = division;
			var temp = expressions[0].split('/');
			lhs = [temp[0] + '/' + temp[1], temp[2] + '/' + temp[3]];
		}
		else	//	found: addition, subtraction, or multiplication
		{
			op = i;	//	set to operation
			lhs = expressions[0].split(ops[i]);
		}
		
		
		equationComponents.lhsFractionA = JFraction.parse(lhs[0]);
		equationComponents.lhsFractionB = JFraction.parse(lhs[1]);
		operation = op;
		equationComponents.rhsFraction = JFraction.parse(expressions[1]);
		
//		console.log(equationComponents.lhsFractionA);
//		console.log(equationComponents.lhsFractionB);
//		console.log(equationComponents.op);
//		console.log(equationComponents.rhsFraction);
//		console.log()
		
	}
}
