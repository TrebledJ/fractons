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
	
	return array.slice(0, index).concat(array.slice(index+1));
}
