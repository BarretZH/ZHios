//--------------------------------------------------------------------------------------------------
//	DKJ Show Muse: BZLibrary.js
//	Written by Hanon HUI
//	Copyright DKJ Company Limited, 2014.  All rights reserved
//--------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------
//	Common constants
//--------------------------------------------------------------------------------------------------
var BZ_EVENT = {
	DEBUG: "debug",
	
	SUBMIT_CHOICE: "submit_choice",
	CONTINUE_LESSON: "continue_lesson",
	SKIP_QUESTION: "skip_question",
	
	CLICK_ADV: "click_advertisement"
};

//--------------------------------------------------------------------------------------------------
//	Custom functions
//--------------------------------------------------------------------------------------------------
//	A function for the document to communicate to the mobile device
function bzEvent(devicePlatform, eventName, parameterString)  {
	var eventString = eventName;
	if (parameterString)  {eventString += "::" + parameterString;}
    
	switch (devicePlatform)  {
		case "android":  {
			Android.onBzEvent(eventString);	
		}  break;
		
		case "ios":  {
			window.location = "bzevent:" + eventString;
		}  break;
		
		default:  {
			window.location = "bzevent://" + eventString;
		}  break;
	}
}

//--------------------------------------------------------------------------------------------------
function shuffle(array)  {
	for (var i = array.length - 1; i > 0; i--)  {
		var j = Math.floor(Math.random() * (i + 1));
        var temp = array[i];
        array[i] = array[j];
        array[j] = temp;
	}
	return array;
}


//--------------------------------------------------------------------------------------------------
//	jQuery extensions
//--------------------------------------------------------------------------------------------------
//	Usage:
//		Create a HTML DOM element with the given tag, attributes and child
//	Example:
//		var div = createDomElement("table", {"class": "fullWidth"}, "Content");
//	Output:
//		A HTML DOM element of jQuery object
function createDomElement(tag, attrs, child)  {
	var domElement = $(document.createElement(tag));
	
	for (var key in attrs)  {
		if (attrs.hasOwnProperty(key))  {
			var value = attrs[key];
			if (value === "")  {continue;}
			
			domElement.attr(key, value);
		}
	}
	
	if (child)  {domElement.append(child);}
	
	return domElement;
}