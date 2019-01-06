.pragma library

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
	'div': '/'
};


function gcd(m, n) {
	if (n > m)
		return gcd(n, m);
	
	return n === 0 ? m : gcd(n, m%n);
}

function randI(low, high) {
	if (arguments.length === 0)
		return;
	
	if (high === undefined)
	{
		high = low;
		low = 0;
	}
	
	low = Math.floor(low);
	high = Math.ceil(high);
	
	return Math.floor(Math.random() * (high - low + 1) + low);	//	+ 1 for the floor
}

function choose(arr) {
	return arr[randI(arr.length - 1)];
}
