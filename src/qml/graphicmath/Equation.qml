import QtQuick 2.0

import "../js/Fraction.js" as JFraction

Row {
	id: row
	
	property real contentWidth: 0
	property real contentHeight: 0
	
	//	stores the equation
	property string text
	
	//	items: stores an array of qml Items added into the row
	property var items: []
	
	//	prepare components to create objects with
	property var textComponent: Qt.createComponent("MathText.qml")
	property var fractionComponent: Qt.createComponent("Fraction.qml")
	property int fontsize: 24
	
	function clear() {
		//	destroy each item
		for (var i = 0; i < items.length; i++)
			items[i].destroy();
		
		items = [];	//	clear array
		
		contentWidth = 0;
		contentHeight = 0;
	}
	
	function appendText(text) {
		var props = {
			text: text
		};

		var obj = textComponent.createObject(row, props);
		obj.anchors.verticalCenter = row.verticalCenter;
		obj.font.pointSize = fontsize;
		items.push(obj);	//	push into array
		
		contentWidth += obj.width;	//	add width
		contentHeight = Math.max(contentHeight, obj.height);	//	check/update height
	}
	
	function appendFraction(fraction) {
		var props = { fraction: fraction };
		var obj = fractionComponent.createObject(row, props);
		obj.anchors.verticalCenter = row.verticalCenter;
		obj.font.pointSize = fontsize;
		items.push(obj);
		
		contentWidth += obj.width;
		contentHeight = Math.max(contentHeight, obj.height);
	}
	
	function parse(text) {
		var buffer = "";	//	holds buffered text
		
		for (var i = 0; i < text.length; i++)
		{
			if (text[i] === '(')
			{
				var ioClosingBracket = text.indexOf(')', i);
				if (ioClosingBracket === -1)
				{
					console.error("Parse Error:", "expected closing bracket in", text);
					return;
				}
				
				appendText(buffer);
				parse(text.substring(i, ioClosingBracket + 1));	//	recurse
				i = ioClosingBracket;
				continue;
			}
			
			if ('+-*÷ '.includes(text[i]))
			{
				appendText(buffer + text[i]);
				buffer = "";
				continue;
			}
			
			if (text[i] === '/')
			{
				//	if buffer is empty or is not a number
				if (buffer === "")
				{
					buffer += text[i];
					continue;
				}

				//	division: do a lookahead for denominator
				var lookaheadIndex = -1;
				for (var j = i + 1; j < text.length; j++)
				{
					if ('+-*÷() '.includes(text[j]))
					{
						lookaheadIndex = j;
						break;
					}
				}
				if (lookaheadIndex === -1)
					lookaheadIndex = text.length;	//	at end
				
				var fracSubText = text.substring(i, lookaheadIndex);
				if (fracSubText !== "")
				{
					appendFraction(JFraction.parse(buffer + fracSubText));
					i = lookaheadIndex - 1;
					buffer = "";
					continue;
				}
				
				continue;
			}
			
			buffer += text[i];
		}
		
		if (buffer.length > 0)
			appendText(buffer);
	}
	
	onTextChanged: { clear(); parse(text); }
	
}
