.pragma library

function toTitleCase(str) {
//	str = str.toLowerCase();
	var ret = "";
	for (var i in str)
	{
		i = Number(i);
		if (i === 0)
			ret += str[i].toUpperCase();
		else if (" ,./?!@#$%^&*()-=_+".includes(str[i - 1]))
			ret += str[i].toUpperCase();
		else
			ret += str[i].toLowerCase();
	}
	
	return ret;
}

function popArray(array, index) {
	if (index === undefined) index = array.length - 1;
	if (index === 0)
		return array.slice(1);
	if (array.length === 0)
		return [];
	if (index >= array.length)
		return array.slice(0, array.length-1);
	
	return array.slice(0, index).concat(array.slice(index+1));
}

function nounify(n, noun, suffix) {
	suffix = suffix || 's';
	
	return n + ' ' + (n === 1 ? noun : noun + suffix);
}

function toMidnight(date) {
	date.setHours(0); date.setMinutes(0); date.setSeconds(0); date.setMilliseconds(0);
	return date;
}

function timeAgo(date, now) {
	now = now || Date.now();
	
	var diff = new Date(now - date);
	
	var hoursAgo = diff.getUTCHours();
	var minutesAgo = diff.getUTCMinutes();
	var daysAgo = diff.getUTCDate() - 1;
	
	var readable = [];
	
	if (daysAgo)
		readable.push(nounify(daysAgo, 'day'));
	
	if (hoursAgo)
		readable.push(nounify(hoursAgo, 'hour'));
		
	if (minutesAgo)
		readable.push(nounify(minutesAgo, 'minute'));
	
	if (readable.length == 0)
		return 'Just now';
		
	return readable.join(' ') + ' ago';
}

function copyArray(arr) {
	return arr.slice();
}
