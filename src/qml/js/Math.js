.pragma library

function gcd(m, n) {
	return n === 0 ? m : gcd(n, m%n);
}

function randI(low, high) {
	return Math.random() * (high - low) + low;
}
