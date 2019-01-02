import VPlay 2.0
import QtQuick 2.0

import "../js/Fraction.js" as JFraction

Row {
	id: row
	
	//	stores the equation
	property string equation
	
	//	items: stores an array of qml Items added into the row
	property var items: []
	
	//	prepare components to create objects with
	property var textComponent: Qt.createComponent("MathText.qml")
	property var fractionComponent: Qt.createComponent("Fraction.qml")
	//	usage (JS):
	//		var <obj_instance> = textComponent.createObject(<parent>, <properties>);
	
	
	
	onEquationChanged: {
		parse(equation);
	}
	
	
	function clear() {
		//	destroy each item
		for (var i = 0; i < items.length; i++)
			items[i].destroy();
		
		items = [];	//	clear array
	}
	
	function appendText(text) {
		var props = {
			text: text
		};

		var obj = textComponent.createObject(row, props);
		obj.anchors.verticalCenter = row.verticalCenter;
		
		items.push(obj);
	}
	
	function appendFraction(fraction) {
		var props = {
			fraction: fraction
		};
		
		var obj = fractionComponent.createObject(row, props);
		obj.anchors.verticalCenter = row.verticalCenter;
		
		items.push(obj);
	}
	
	function parse(text) {
		clear();
		
		console.debug("Parsing", text);
		
		
		var buffer = "";	//	holds buffered text
		
		for (var i = 0; i < text.length; i++)
		{
			console.debug("\nIndex", i, ':', text[i]);
			
			if (text[i] === '(')
			{
				console.debug("Is Bracket");
				
				var ioClosingBracket = text.indexOf(')', i);
				if (ioClosingBracket === -1)
				{
					console.error("Parse Error:", "expected closing bracket in", text);
					return;
				}
				
				appendText(buffer);
				
				var bracketed = text.substring(i, ioClosingBracket + 1);
				parse(bracketed);
				
				i = ioClosingBracket;
				continue;
			}
			
			if ('+-*'.includes(text[i]))
			{
				console.debug("Is +-*");
				
				appendText(buffer + text[i]);
				buffer = "";
				continue;
			}
			
			if (text[i] === '/')
			{
				console.debug("Is division operator");
				
				//	if buffer is empty or is not a number
				if (buffer === "" || isNaN(buffer))
				{
					console.debug("Buffer is empty/invalid, skipping division...")
					
					buffer += text[i];
					continue;
				}

				console.debug("Performing lookahead");
				
				//	division: do a lookahead for denominator
				var lookaheadIndex = -1;
				for (var j = i + 1; j < text.length; j++)
				{
					if ('+-*()'.includes(text[j]))
					{
						lookaheadIndex = j;
						break;
					}
				}
				if (lookaheadIndex === -1)
					lookaheadIndex = text.length - 1;	//	at end
				
				console.debug("Finished lookahead at index", lookaheadIndex);
				
				
				var fracSubText = text.substring(i, lookaheadIndex + 1);
				console.debug("Retrieved substring", fracSubText);
				
				if (fracSubText !== "" && !isNaN(fracSubText.substr(1)))
				{
					console.debug("Substring is somewhat fraction-parsible.");
					
					var fracText = buffer + fracSubText;
					console.debug("Checking full fraction-parsibility text", fracText);
					if (JFraction.isParsible(fracText))
					{
						console.debug(fracText, "IS fraction-parsible");
						
						appendFraction(JFraction.parse(fracText));
						
						i = lookaheadIndex;
						buffer = "";
						continue;
					}
				}
				
				continue;
			}
			
			buffer += text[i];
		}
		
		if (buffer.length > 0)
			appendText(buffer);
	}
}
