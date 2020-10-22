Cordova Clipboard API
=========

[![npm version](https://badge.fury.io/js/cordova-clipboard-api.svg)](https://badge.fury.io/js/cordova-clipboard-api)

Clipboard management plugin for Cordova/PhoneGap that supports images, text and urls for iOS. Android support is limited to text content only.

## Installation

```
cordova plugin add cordova-clipboard-api
```

The plugin creates the object `cordova.plugins.clipboard` with the methods `copy(options, callback)`, `paste(callback)` and `clear()`.

## Methods

### Copy()

`copy(options, callback)`

The `options` object contains two properties: `type` and `data`.

- *type* - One of "text", "url" or "image"
- *data* - Data to be sent to clipboard

Callback will contain an object:
```
{
	type: "ex: text", // type value submitted to plugin
	data: "ex: Howdy Partner!", // data submitted to plugin
	error: false // false if successful. Exception text if not.
}
```

#### Copy Text (iOS/Android)
```
window.cordova.plugins.clipboard.copy({
	type: "text", // default, so not needed for text
	data: "Howdy Partner!"
}, (res) => {
	console.log(res);
});
```

#### Copy URL (iOS only)
```
window.cordova.plugins.clipboard.copy({
	type: "url",
	data: "https://yesorno.io/"
}, (res) => {
	console.log(res.type);
});
```

#### Copy Image (iOS only)

*NOTE:* Only tested with remote URLs so far.

```
let imageUrl = "https://placedog.net/500";

// get blob of image (example only, use whatever method you like!)
fetch(url)
.then((response) => {
	return response.blob();
}).then((blob) => {
	let reader = new FileReader() ;
	reader.onload = (res) => { 
		window.cordova.plugins.clipboard.copy({
			type: 'image',
			data: res.target.result
		}, (res) => {
			console.log(res);
		});
	};
	reader.readAsDataURL(blob) ;
});
```
---

### Paste()

`paste(callback)`

Callback will contain an object:
```
{
	type: "ex: text", // type of data coming from clipboard
	data: "ex: Howdy Partner!", // data coming from clipboard
}
```

*NOTE:* Pasted images in iOS will always be base64-encoded string.
Example: `data:image/png;base64,iVBORw0KGgoAAAAN...`

#### Paste Data from Clipboard
```
window.cordova.plugins.clipboard.paste((res) => {
	if(res.type == "text"){
		this.text = res.data;
	}
});
```
---

### clear()

`clear()`

#### Clear Data from Clipboard
```
window.cordova.plugins.clipboard.clear();
```

## Notes

### Testing

- This plugin hasn't been tested on a ton of physical devices yet. Please file an issue should you find a bug!

### iOS

- The minimum supported version of iOS is v7.0.

### Android

- Android version only supports text content.
- The minimum supported API Level is 11. Make sure that `minSdkVersion` is larger or equal to 11 in `AndroidManifest.xml`.

## Acknowledgements

This plugin began as a fork of [CordovaClipboard](https://github.com/ihadeed/cordova-clipboard) which was inspired by [ClipboardManagerPlugin](https://github.com/jacob/ClipboardManagerPlugin) (Android) and [ClipboardPlugin](https://github.com/phonegap/phonegap-plugins/tree/master/iPhone/ClipboardPlugin) (iOS).

This plugin adds support for urls and images (iOS only) as well as provides a more complete callback object with error handling.

## License

The MIT License (MIT)

Copyright (c) 2020 Michael Wuori

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
