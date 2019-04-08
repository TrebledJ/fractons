import QtQuick 2.0

import "../backdrops"
import "../../common"
import "../../graphicmath/"
import "../../game/singles"

import "../../js/Fraction.js" as JFraction
import "../../js/Math.js" as JMath

ModesBase {
	id: modesBase
	
	//	== PROPERTY DECLARATIONS ==
	property int operation: addition
	readonly property int addition: 0
	readonly property int subtraction: 1
	readonly property int multiplication: 2
	readonly property int division: 3
	readonly property int easy: 0
	readonly property int medium: 1
	readonly property int hard: 2
	
	
	//	== JS FUNCTIONS ==
	
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
		
		var lhs = equationComponents.solveLHS();
		
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
	
	function getCorrectAnswer() {
		var lhs = equationComponents.solveLHS();
		
		if (difficultyIndex === easy)
			return String(lhs.n);
		
		return lhs.toString() + (lhs.isSimplified() ? '' : ' or ' + lhs.simplified());
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
				n2 = JMath.randI(1, n1-1);
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
	}
	
	
	//	== OBJECT PROPERTIES ==
	
	difficulties: ["Easy", "Medium", "Hard"]
	modeName: 'Operations'
	rewardAmount: [1, 2, 5][difficultyIndex]
	unit: "fractons"
	
	help: Item {
		Column {
			width: parent.width
			spacing: 20
			
			TextBase { text: "Operations Mode" }
			ParagraphText { text: "In this mode, you gain ƒractons by performing operations on fractions." }
			TextBase { text: "Example:" }
			Equation {
				anchors.horizontalCenter: parent.horizontalCenter
				text: ["1/3 + 1/3 = ?/3", "1/2 * 1/2 = ?/?", "1/2 + 1/4 = ?/?"][difficultyIndex]
			}
			TextBase { text: "Answer: " + ["2", "1/4", "3/4"][difficultyIndex] }
		}
	}
	
	//	displays the equation as text
	centerpiece: Equation {
		id: equation
		text: hasInputError || userInput().length === 0 ? equationComponents.join() : equationComponents.dynamicJoin()
	}
	
	
	QtObject {
		id: equationComponents
		
		property var lhsFractionA: new JFraction.Fraction()
		property var lhsFractionB: new JFraction.Fraction()
		property var rhsFraction: new JFraction.Fraction('?')
		
		readonly property string op: {
			if (operation === addition) return '+';
			else if (operation === subtraction) return '-';
			else if (operation === multiplication) return '*';
			else if (operation === division) return '/';
			return '?';
		}
		
		function join() {
			return lhsFractionA + ' ' + op + ' ' + lhsFractionB + ' = ' + rhsFraction;
		}
		
		function solveLHS() {
			return (operation === addition ? lhsFractionA.add(lhsFractionB) :
					operation === subtraction ? lhsFractionA.sub(lhsFractionB) : 
					operation === multiplication ? lhsFractionA.mul(lhsFractionB) :
					operation === division ? lhsFractionA.div(lhsFractionB) :
											 lhsFractionA);
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
			return lhsFractionA + ' ' + op + ' ' + lhsFractionB + ' = ' + reparseRhs(userInput());
		}
	}
}
