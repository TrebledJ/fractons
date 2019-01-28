.pragma library

Qt.include("Math.js");

/**
Documentation

Class: Fraction

Members Variables:
  n : int
  d : int
  
Methods:
  Fraction		simplified()
  bool			isSimplified()
  bool			equals(other: Fraction)
  Fraction		add(other: Fraction)
  Fraction		sub(other: Fraction)
  Fraction		mul(other: Fraction)
  Fraction		div(other: Fraction)
  Fraction		toNumericFraction()
  bool			isInteger()
  int			toInteger()
  bool			isValid()
  Fraction		copy()
  string		toString()

Static Non-Class Methods:
  bool			isParsible(input: string)
  int			isParsibleWithError(input: string)
  Fraction		parse(input: string)

Enum Object:
  ParsingError: int -> string { 0..4 }
  
**/


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
		if (!this.isValid() || !other.isValid())
			return false;
		
		if (this.n === 0 && other.n === 0)
			return true;
		
		if (this.n === other.n && this.d === other.d)
			return true;
		
		if (this.isSimplified() && other.isSimplified())
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
	
	this.isInteger = function() {
		if (!this.isValid())
			return false;
		
		if (this.n === 0)
			return true;
		
		return this.n % this.d === 0;
	}
	
	//	if not divisible, return floor to guarantee integer
	this.toInteger = function() {
		if (this.isInteger())
			return this.n / this.d;
		
		return Math.floor(this.n / this.d);
	}
	
	//	checks equity with a numeric value
	this.equalsValue = function(other) {
		var frac = this.toNumericFraction();
		return frac.n / frac.d === other;
	}
	
	this.isValid = function() {
		return this.d != 0 && !isNaN(this.n) && !isNaN(this.d);
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
	1: "Program Error: Undefined input passed into `Fraction.isParsibleWithError` function.",
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
	
//	var tokens = input.split(' ').filter(function(t){ return t.trim() !== ""; });
//	var fracTokens = tokens.join('').split('/');
	
	var tokens = input.replace(/ /g, '');
	var fracTokens = tokens.split('/');
	
	
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
