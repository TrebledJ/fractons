import QtQuick 2.0

import "../backdrops"
import "../../graphicmath"

import "../../js/Fraction.js" as JFraction
import "../../js/Math.js" as JMath

//	TODO consider the difficulties and their roles and differences?

ModesBase {
	id: modesBase
	
//	difficulties: ["Easy", "Hard"]
//	difficulties: ["Easy"]
//	readonly property int easy: 0
//	readonly property int hard: 1
	
	modeName: 'Balance'
	rewardAmount: 1
	unit: "fractons"
	
	
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
		text: hasInputError || answerField.text.length === 0 ? equationComponents.join() : equationComponents.dynamicJoin()
	}
	
	function hasParsingError(text) {
		var errCode = JFraction.isParsibleWithError(text);
		return errCode;
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
			rejectInput(JFraction.ParsingError[errCode]);
			return false;
		}
		
		acceptInput();
		return true;
	}
	
	//	ans: JFraction.Fraction
	//	return: bool
	function checkAnswer(text) {
		var ans = JFraction.parse(text);
		
//		if (difficultyIndex === easy && !ans.isInteger())	//	no difficulties for now
		if (!ans.isInteger())
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
		
//		//	generate lhs fraction
//		var dLeft = JMath.randI(2, 12);
//		var nLeft = JMath.randI(1, dLeft - 1);
		
//		equationComponents.lhsFraction = new JFraction.Fraction(nLeft, dLeft);
		
//		//	generate rhs fraction
//		var top = 0, bottom = 1;
//		var questionMark = JMath.choose([top, bottom]);
		
//		var nRight = '?', dRight = '?';
		
//		if (questionMark === top)
//		{
//			dRight = dLeft * JMath.randI(2, 4);		//	denominator
//		}
//		else if (questionMark === bottom)
//		{
//			nRight = nLeft * JMath.randI(2, 4);		//	numerator
//		}
		
//		//	special for lhs not simplified
//		if (!equationComponents.lhsFraction.isSimplified())
//		{
//			//	if useSimplifiedFraction is true it becomes a simplification exercise
//			var useSimplifiedFraction = JMath.randI(false, true);
//			if (useSimplifiedFraction)
//			{
//				if (questionMark === top)
//					dRight = equationComponents.lhsFraction.simplified().d;	//	denominator
//				else if (questionMark === bottom)
//					nRight = equationComponents.lhsFraction.simplified().n;	//	numerator
//			}
//		}
			
		
//		equationComponents.rhsFraction = new JFraction.Fraction(nRight, dRight);
		
		//	----
		
		var n_l, d_l, n_r, d_r;
		
		//	choose a left fraction
		d_l = JMath.randI(2, 8);
		n_l = JMath.randI(1, d_l-1);
		
		//	get the maximum factor
		var maxFactor = Math.floor(16 / d_l);
		console.log("Max Factor:", maxFactor);
		
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
		
		//	random chance to swap
		var swap = JMath.coin();
		
		var lhs = swap ? new JFraction.Fraction(n_r, d_r) : new JFraction.Fraction(n_l, d_l);
		var rhs = swap ? new JFraction.Fraction(n_l, d_l) : new JFraction.Fraction(n_r, d_r);
		
		//	random chance: either numerator or denominator is fraction
		var top = JMath.coin();
		
		if (top) rhs.n = '?';
		else	 rhs.d = '?';
		
		
		
		equationComponents.lhsFraction = lhs;
		equationComponents.rhsFraction = rhs;
		
	}
}
