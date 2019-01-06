.pragma library

Qt.include("Math.js");

function Fraction(n, d) {
	this.n = (n !== undefined ? n : 0);
	this.d = (d !== undefined && d !== 0 ? d : 1);
	
	this.simplified = function() {
		if (this.n === 0)
			return new Fraction(0, 1);
		
		var g = gcd(this.n, this.d);
		return new Fraction(n/g, d/g);
	}
	
	this.isSimplified = function() {
		return gcd(this.n, this.d) === 1;
	}
	
	this.equals = function(other) {
		if (this.n === 0 && other.n === 0)
			return true;
		
		if (this.n === other.n && this.d === other.d)
			return true;
		
		if (this.isSimplified())
			return false;
		
		return this.simplified().equals(other.simplified());
	}
	
	this.add = function(other) {
		var lhs = this.toNumericFraction();
		var rhs = other.toNumericFraction();
		
		if (lhs.d === rhs.d)
			return new Fraction(lhs.n + rhs.n, lhs.d);
		
		return new Fraction(lhs.n * rhs.d + lhs.d * rhs.n, lhs.d * rhs.d);
	}
	
	this.sub = function(other) {
		var lhs = this.toNumericFraction();
		var rhs = other.toNumericFraction();
		
		if (lhs.d === rhs.d)
			return new Fraction(lhs.n - rhs.n, lhs.d);
		
		return new Fraction(lhs.n * rhs.d - lhs.d * rhs.n, lhs.d * rhs.d);
	}
	
	this.mul = function(other) {
		var lhs = this.toNumericFraction();
		var rhs = other.toNumericFraction();
		
		return new Fraction(lhs.n * rhs.n, lhs.d * rhs.d);
	}
	
	this.div = function(other) {
		var lhs = this.toNumericFraction();
		var rhs = other.toNumericFraction();
		
		return new Fraction(lhs.n * rhs.d, lhs.d * rhs.n);
	}
	
	//	n and d might've been strings from the parse function, this will convert them to numbers
	this.toNumericFraction = function() {
		return new Fraction(Number(this.n), Number(this.d));
	}
	
	this.isValid = function() {
		return this.d != 0 && isNaN(this.n) && isNaN(this.d);
	}
	
	this.copy = function() {
		return new Fraction(this.n, this.d);
	}
	
	this.toString = function() {
		return this.n + '/' + this.d;
	}
}


var ParsingError = {
	0: "",
	1: "Program Error: No input passed into `Fraction.isParsible` function",
	2: "Too many '/' symbols",
	3: "Expected numeric value: '[0-9]'",
	4: "Expected numeric value before and after '/': '[0-9]/[0-9]'"
};

var isParsible = function(input) {
	return isParsibleWithError(input) === 0;
}

var isParsibleWithError = function(input) {
	if (input === undefined)
		return 1;
	
	if (input.length === 0)
		return 0;
	
	var tokens = input.split(' ').filter(function(t){ return t.trim() !== ""; });
	
	var fracTokens = tokens.join('').split('/');
	if (fracTokens.length > 2)
		return 2;
	
	if (fracTokens[0] === "" || isNaN(fracTokens[0]))
	{
		if (fracTokens.length === 1)
			return 3;
		else if (fracTokens.length === 2)
			return 4;
	}
	
	if (fracTokens.length === 2 && (fracTokens[1] === "" || isNaN(fracTokens[1])))
		return 4;
	
	return 0;
}

/**
  \brief takes a string input and parses the numerator and denominator as strings
  \param input: string
 **/
var parse = function(input) {
//	var fracTokens = input.split(' ').filter(function(t){ return t.trim() !== ""; }).join('').split('/');
	var fracTokens = input.replace(/ /g, '').split('/');
	
	var numerator = fracTokens[0];
	var denominator = (fracTokens.length < 2 ? 1 : fracTokens[1]);
	return new Fraction(numerator, denominator);
}
