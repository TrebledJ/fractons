import QtQuick 2.0

import "../backdrops"
import "../../common"
import "../../graphicmath"

import "../../js/Fraction.js" as JFraction
import "../../js/Math.js" as JMath

ModesBase {
	id: modesBase
	
//	difficulties: ["Easy", "Hard"]
//	difficulties: ["Easy"]
//	readonly property int easy: 0
//	readonly property int hard: 1
	
	modeName: 'Balance'
	rewardAmount: 1
	unit: "fractons"
	
	info: Item {
		Column {
			width: parent.width
			spacing: 20
			
			TextBase {
				text: "Balance Mode"
			}
			
			ParagraphText {
				text: "In this mode, you gain ƒractons by balancing the fractions on both sides of the equation."
			}
			
			TextBase {
				text: "Example:"
			}
			
			Equation {
				anchors.horizontalCenter: parent.horizontalCenter
				text: "1/2 = ?/6"
			}
			
			TextBase {
				text: "Answer: 3"
			}
		}
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
			return lhsFraction + ' = ' + reparseRhs(userInput());
		}
	}
	
	centerpiece: Equation {
		id: equation
		text: hasInputError || userInput().length === 0 ? equationComponents.join() : equationComponents.dynamicJoin()
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
	
	function getCorrectAnswer() {
		var lhs = equationComponents.lhsFraction.value();
		if (equationComponents.rhsFraction.n === '?')
			return lhs * equationComponents.rhsFraction.d;
		
		return equationComponents.rhsFraction.n / lhs;
	}
	
	function generateRandomQuestion() {
		
		var n_l, d_l, n_r, d_r;
		
		//	choose a left fraction
		d_l = JMath.randI(2, 8);
		n_l = JMath.randI(1, d_l-1);
		
		//	get the maximum factor
		var maxFactor = Math.floor(16 / d_l);
		
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
	
//	//	== If there is more than one difficulty: == //
	
//	//	encodes the current question's state
//	function getQuestionState() {
		
//	}
	
//	//	decodes the state provided
//	function parseQuestionState(state) {
		
//	}
}
