var fs = require('fs')
const IMAGES_CID = 'Qmca6m6iafnWFEDYB5t3jzncQ6y6N1DgcSuh8LrfjtAYm8';
console.log('IMAGES_CID', IMAGES_CID);
//Error message if no args
if (process.argv.length != 4) return console.log('Enter first and last emoji number.');
const myArgs = process.argv.slice(2);
var first = parseInt(myArgs[0]);
var last = parseInt(myArgs[1]);

for (var i = first; i <= last; i++) {
    var fileName = 'json/Emoji ' + i.toString() + '.json';
    console.log('Updating file', fileName);
    const data = fs.readFileSync(fileName, { encoding: 'utf8', flag: 'r' });
    console.log('before', data);

    var result = data.replace("IMAGES_CID", IMAGES_CID);
    console.log('after', result);
    fs.writeFileSync(fileName, result);
}
