.pragma library

Qt.include(Qt.resolvedUrl("Utils.js"));

/*
  gcd example
  120, 45
  m			n	 r
  120 = 2 * 45 + 30
  45 = 2 * 30 + 15
  30 = 2 * 15 + 0
  gcd = 15
  */

var operations = {
	'add': '+',
	'sub': '-',
	'mul': '*',
	'div': '/',
	'eq': '=',
	'ne': '≠',
	'lt': '<',
	'le': '≤',
	'gt': '>',
	'ge': '≥'
};


//	calculates the greatest common denominator between two numbers using the Euclidean algorithm
function gcd(m, n) {
	if (n > m)
		return gcd(n, m);
	
	return n === 0 ? m : gcd(n, m%n);
}

//	returns a random integer between low and high inclusive
function randI(low, high) {
	if (arguments.length === 0)
		return;
	
	if (high === undefined)
	{
		high = low;
		low = 0;
	}
	
	if (low > high)
		return randI(high, low);
	
	low = Math.floor(low);
	high = Math.ceil(high);
	
	return Math.floor(Math.random() * (high - low + 1) + low);	//	+ 1 for the floor
}

//	chooses a random element in an Array or String
function choose(arr, n, replace) {
	if (n === undefined) n = 1;
	if (replace === undefined) replace = false;
	
	if (n >= arr.length)
	{
		if (arr.length === 1)
			return arr[0];
		return arr;
	}
	
	if (n <= 0)
		return [];
	
	var ret = [];
	if (!replace)
	{
		var remainingIndices = [];
		for (var i = 0; i < arr.length; i++) remainingIndices.push(i);
		for (var _ = 0; _ < n; _++)
		{
			var indexOfIndex = randI(remainingIndices.length - 1);	//	choose a the secondaryIndex
			var index = remainingIndices[indexOfIndex];	//	grab the arrIndex
			
			remainingIndices = popArray(remainingIndices, indexOfIndex);	//	pop the array
			
			ret.push(arr[index]);	//	push the item into the returning container
			
		}
	}
	else /* replace */
	{
		for (var _ = 0; _ < n; _++)
		{
			ret.push(arr[randI(arr.length - 1)]);
		}
	}
	
	if (n === 1)
		return ret[0];
	
	return ret;
//	return arr[randI(arr.length - 1)];
}

//	returns a 50-50% probability
function coin() {
	return Math.random() > 0.5;
}

//	returns true if a probability successfully fell past 1/n
function oneIn(n) {
	return Math.random() < 1/n;
}

//	returns a list of numbers in the range [start, end)
function range(start, end) {
	var ret = [];
	for (var i = start; i < end; i++)
		ret.push(i);
	return ret;
}

//	prime-factorises n 
function primeFactors(n) {
	var ret = [];
	
	while (n % 2 == 0)
	{
		ret.push(2);
		n /= 2;
	}
	
	for (var i = 3; i*i <= n; i+=2)
	{
		while (n % i == 0)
		{
			ret.push(i);
			n /= i;
		}
	}
	
	return ret;
}

//	finds all numbers between 1 and n inclusive which divide n
function factors(n) {
	var ret = [];
	for (var i = 1; i <= n; i++)
		if (n % i == 0)
			ret.push(i);
	
	return ret;
}
