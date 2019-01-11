import VPlay 2.0
import QtQuick 2.0

import "../backdrops"
import "../../graphicmath"

import "../../js/Fraction.js" as JFraction
import "../../js/Math.js" as JMath

//	TODO consider the difficulties and their roles and differences?

ModesBase {
	id: modesBase
	
	difficulties: ["Easy", "Hard"]
	readonly property int easy: 0
	readonly property int hard: 1
	
	Component.onCompleted: {
		generateRandomQuestion();
	}
	
	QtObject {
		id: equationComponents
		property var lhsFraction: new JFraction.Fraction()
		property var rhsFraction: new JFraction.Fraction()
		
		function join() {
			return lhsFraction + ' = ' + rhsFraction;
		}
		
		//	substitutes arguments in place of question marks, no error checking is done
		//	input: JFraction.Fraction.string
		//	return: JFraction.Fraction
		function reparseRhs(input) {
			
			//	parse input as fraction
			var frac = JFraction.parse(input);
			
			//	in BALANCE mode, there will always be only one question mark
			
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
			return lhsFraction + ' = ' + reparseRhs(answerField.text);
		}
	}
	
	Equation {
		id: equation
		anchors.centerIn: drawingArea
		equation: hasInputError || answerField.text.length === 0 ? equationComponents.join() : equationComponents.dynamicJoin()
	}
	
	onDifficultyIndexChanged: generateRandomQuestion();
	onGoButtonClicked: handleInput();
	
	function handleInput() {
		var text = answerField.text;
		
		if (text.length === 0)
		{
			rejectInput("Expected input.")
			return;
		}
		
		var errCode = JFraction.isParsibleWithError(text);
		if (errCode)
		{
			rejectInput(JFraction.ParsingError[errCode]);
			return;
		}
		
		acceptInput();
		
		var fraction = JFraction.parse(text);
		var isCorrect = checkAnswer(fraction);
		if (isCorrect)
		{
			addCombo();
			
			addXp(difficultyIndex === hard ? 2 : 1);
		}
		else
		{
			resetCombo();
		}
		
		clearInput();
		generateRandomQuestion();
	}

	//	ans: JFraction.Fraction
	//	return: bool
	function checkAnswer(ans) {
		
		if (difficultyIndex === easy && !ans.isInteger())
		{
			console.debug("Answer is not Integer");
			return false;
		}
		
		var lhs = equationComponents.lhsFraction;
		var rhs = equationComponents.reparseRhs(ans.toString());
		var res = lhs.toNumericFraction().equals(rhs.toNumericFraction());
		
		console.debug("Question:", equationComponents.join());
		console.debug("Answer:", "'" + lhs + "'", "(or", lhs.simplified() + ")", "versus", "'" + rhs + "'", ':', res);
		
		return res;
	}
	
	function generateRandomQuestion() {
		
		//	generate lhs fraction
		var dLeft = JMath.randI(2, 12);
		var nLeft = JMath.randI(1, dLeft - 1);
		
		equationComponents.lhsFraction = new JFraction.Fraction(nLeft, dLeft);
		
		//	generate rhs fraction
		var top = 0, bottom = 1;
		var questionMark = JMath.randI(top, bottom);
		
		var nRight = '?', dRight = '?';
		
		if (questionMark === top)
		{
			dRight = dLeft * JMath.randI(2, 5);		//	denominator
		}
		else if (questionMark === bottom)
		{
			nRight = nLeft * JMath.randI(2, 5);		//	numerator
		}
		
		//	special for lhs not simplified
		if (!equationComponents.lhsFraction.isSimplified())
		{
			//	make this a simplification exercise ?
			var useSimplifiedFraction = JMath.randI(false, true);
			if (useSimplifiedFraction)
			{
				if (questionMark === top)
					dRight = equationComponents.lhsFraction.simplified().d;	//	denominator
				else if (questionMark === bottom)
					nRight = equationComponents.lhsFraction.simplified().n;	//	numerator
			}
		}
			
		
		equationComponents.rhsFraction = new JFraction.Fraction(nRight, dRight);
	}
}
