.pragma library

Qt.include("Math.js");

function Fraction(n, d) {
	this.n = (n !== undefined ? n : 0);
	this.d = (d !== undefined || d === 0 ? d : 1);
	
	
	this.simplify = function() {
		var g = gcd(this.n, this.d);
		return new Fraction(n/g, d/g);
	}
	
	this.isSimplified = function() {
		return gcd(this.n, this.d) === 1;
	}
	
	this.equals = function(other) {
		if (this.n === other.n && this.d === other.d)
			return true;
		else
		{
			if (this.isSimplified())
				return false;
		}
		
		return this.simplify().equals(other.simplify);
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

var isParsible = function(input) {
	return isParsibleWithError(input) === "";
}

var isParsibleWithError = function(input) {
	if (input === undefined)
		return "Program Error: No input passed into `Fraction.isParsible` function";
	
	if (input.length === 0)
		return "";
	
	var tokens = input.split(' ').filter(function(t){ return t.trim() !== ""; });
	
	var fracTokens = tokens.join('').split('/');
	if (fracTokens.length > 2)
		return "Too many '/' symbols";
	
	if (fracTokens[0] === "" || isNaN(fracTokens[0]))
	{
		if (fracTokens.length === 1)
			return "Expected numeric value: '[0-9]'";
		else if (fracTokens.length === 2)
			return "Expected numeric value before '/': '[0-9]/" + fracTokens[1] + "'";
	}
	
	if (fracTokens.length === 2 && (fracTokens[1] === "" || isNaN(fracTokens[1])))
		return "Expected numeric value before '/': '" + fracTokens[0] + "/[0-9]'";
	
	return "";
}

var parse = function(input) {
	var fracTokens = input.split(' ').filter(function(t){ return t.trim() !== ""; }).join('').split('/');
	
	var numerator = Number(fracTokens[0]);
	var denominator = (fracTokens.length < 2 ? undefined : Number(fracTokens[1]));
	
	return new Fraction(numerator, denominator);
}
