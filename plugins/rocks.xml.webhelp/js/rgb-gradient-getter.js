function hexToRgb(hex) {
    // Expand shorthand form (e.g. "03F") to full form (e.g. "0033FF")
    var shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i;
    hex = hex.replace(shorthandRegex, function(m, r, g, b) {
        return r + r + g + g + b + b;
    });

    var result = /^#?([a-fA-F\d]{2})([a-fA-F\d]{2})([a-fA-F\d]{2})$/i.exec(hex);
    return result ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16)
    } : null;
}

function getDarkerRGBColor(r, g, b, ff) {
    r = r*ff;
    g = g*ff;
    b = b*ff;

    return ('rgb(' + Math.round(r) + ',' + Math.round(g) + ',' + Math.round(b) + ')');
}

function getGradientArray (r, g, b, ff, step) {
    var gradient = [];
    gradient.push(getDarkerRGBColor(r, g, b, ff));

    while (ff > step) {
        ff = Math.round((ff - step) * 100) / 100;
        gradient.push(getDarkerRGBColor(r, g, b, ff));
    }

    return gradient;
}

function getGradient(hexcode, formFactor, formFactorStep) {

    console.log('hex orig           = ' + hexcode);

    if (hexcode.length < 5) {
        var shorthandRegex = /^#?([a-fA-F\d])([a-fA-F\d])([a-fA-F\d])$/i;
        hexcode = hexcode.replace(shorthandRegex, function(m, r, g, b) {
            return r + r + g + g + b + b;
        });
    }

    console.log('hex 6 digits       = ' + hexcode);

    hexcode = hexcode.replace(/#?(.*)/, '$1');

    console.log('hex no hash        = ' + hexcode);

    var r = hexToRgb(hexcode).r;
    var g = hexToRgb(hexcode).g;
    var b = hexToRgb(hexcode).b;

    console.log('rgb red            = ' + r);
    console.log('rgb green          = ' + g);
    console.log('rgb blue           = ' + b);

    return getGradientArray(r, g, b, formFactor, formFactorStep);
}

// var hexcode = '#20c5d4';
var hexcode = '#F00';
// var hexcode = '#ff0000';

var formFactor = 0.8;
// var formFactor = 0.6;
// var formFactor = 1;

var formFactorStep = 0.1;

console.log(getGradient(hexcode, formFactor, formFactorStep));