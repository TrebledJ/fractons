import VPlay 2.0
import QtQuick 2.0

import "../backdrops"
import "../../common"
import "../../graphicmath/" as GMath

import "../../js/Fraction.js" as JFraction
import "../../js/Math.js" as JMath

//	todo implement velocity

ModesBase {
	id: modesBase
	
//	property int difficulty: easy
	property int operation: addition
	readonly property int addition: 0
	readonly property int subtraction: 1
	readonly property int multiplication: 2
	readonly property int division: 3
	
	difficulties: ["Easy", "Medium", "Hard"]
	readonly property int easy: 0
	readonly property int medium: 1
	readonly property int hard: 2
	
	Component.onCompleted: {
		generateRandomQuestion();
	}
	
	QtObject {
		id: equationComponents
		property var lhsFractionA: new JFraction.Fraction()
		property var lhsFractionB: new JFraction.Fraction()
		
		//	+, -, *, or ÷
		property string op: {
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
		
		function join() {
			return lhsFractionA + ' ' + op + ' ' + lhsFractionB + ' = ' + rhsFraction
		}
		
		//	substitutes arguments in place of question marks
		function reparseRhs(args) {
			var counter = 0;
			var frac_s = rhsFraction.toString();
			
			while (frac_s.indexOf('?') !== -1)
			{
				var i = frac_s.indexOf('?');
				frac_s = frac_s.substring(0, i) + arguments[counter] + frac_s.substring(i + 1);
				
				counter++;
			}
			
			return JFraction.parse(frac_s);
		}
	}
	
	//	displays the equation as text
	GMath.Equation {
		id: equation
		anchors.centerIn: drawingArea
//		anchors.left: drawingArea.left
//		anchors.leftMargin: 15
//		anchors.verticalCenter: drawingArea.verticalCenter
		
		equation: equationComponents.join();
	}
	
//	BubbleButton {
//		id: difficultyButton
//		width: textBase.contentWidth + 10; height: 30
		
//		anchors {
//			top: modesBase.top
//			left: drawingArea.left
//			margins: 10
//		}
		
//		text: {
//			if (difficulty === easy)
//				return "Difficulty: Easy";
//			if (difficulty === medium)
//				return "Difficulty: Medium";
//			if (difficulty === hard)
//				return "Difficulty: Hard";
//			return "?";
//		}
//		animateText: false
//		color: "yellow"
		
//		onClicked: {
//			difficulty = (difficulty + 1) % (Math.max(easy, medium, hard) + 1);
//			generateRandomQuestion();
//		}
//	}
	
	onDifficultyChanged: /*params: {int index, string difficulty} */ {
		generateRandomQuestion();
	}
	
	Connections {
		target: goButton
		
		onClicked: {
			var text = answerField.text;
			
			if (text.length === 0)
			{
				showInputError("Expected input.")
				return;
			}
			
			var errCode = JFraction.isParsibleWithError(text);
			if (errCode)
			{
				showInputError(JFraction.ParsingError[errCode]);
				return;
			}
			
			acceptInput();
			
			var fraction = JFraction.parse(text);
			var correct = checkAnswer(fraction);
			if (correct)
			{
				//	TODO update where combo and xp are stored
				addCombo();
				
				addXp(difficultyIndex === hard ? 5 :
					  difficultyIndex === medium ? 3 :
												   1);
			}
			else
			{
				resetCombo();
			}
			
			clearInput();
			generateRandomQuestion();
		}
	}
	
	
	Connections {
		target: modesBase.answerField
		
		onTextChanged: {
			var text = modesBase.answerField.text;
			var errCode = JFraction.isParsibleWithError(text);
			modesBase.hasInputError = (errCode !== 0);
		}
	}
	
	//	receives an answer input as a fraction and checks the values
	function checkAnswer(ans) {
		//	numerator always an argument, if only one ?, but ans has two params
		
		if (equationComponents.rhsFraction.d !== '?')
		{
			if (!ans.isInteger())
				return false;
		}
		
		
		var rhs = (equationComponents.rhsFraction.d !== '?' ? equationComponents.reparseRhs(ans.toInteger()) : ans);
		
		var lhs = (operation === addition ? equationComponents.lhsFractionA.add(equationComponents.lhsFractionB) :
					operation === subtraction ? equationComponents.lhsFractionA.sub(equationComponents.lhsFractionB) : 
					operation === multiplication ? equationComponents.lhsFractionA.mul(equationComponents.lhsFractionB) :
					operation === division ? equationComponents.lhsFractionA.div(equationComponents.lhsFractionB) :
											 equationComponents.lhsFractionA);
		
		var res = lhs.equals(rhs.toNumericFraction());
		console.debug("Question:", equationComponents.join());
		console.debug("Answer:", "'" + lhs + "'", "(or", lhs.simplified(), ")", "versus", "'" + rhs + "'", ':', res);
		return res;
	}
	
	//	updates equationComponents with new values ('new' is not guaranteed)
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
	
}
