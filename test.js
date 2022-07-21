var request = require('request');

var cookieString = 'ZDEDebuggerPresent=php,phtml,php3; PHPSESSID=a4tql1j0b11p2om7l8sdclem4sler8ln'
var cookie = request.cookie(cookieString)

const jsdom = require("jsdom");
const { JSDOM } = jsdom;
global.document = new JSDOM('https://qldt.ctu.edu.vn/htql/dkmh/student/index.php?action=dmuc_mhoc_hky?cmbHocKy=1&cmbNamHoc=2023&txtMaMH=CT223&curPage=+&flag=1&Button=T%C3%ACm&txtUserID=').window.document;

var form = {
cmbHocKy: "1",
cmbNamHoc: "2023",
txtMaMH: "CT223",
curPage: "+",
flag: "1",
Button: "T%C3%ACm",
txtUserID: "",
}


var headers = {
    'Content-Type': 'application/json',
    'Cookie': cookie
}
var options = {
    url: 'https://qldt.ctu.edu.vn/htql/dkmh/student/index.php?action=dmuc_mhoc_hky',
    method: 'POST',
    headers: headers,
    form: form
};
request(options, function (error, response, body) {
    if (!error && response.statusCode === 200) {
        // Print out the response body
        const dom = new jsdom.JSDOM(response.body);
        console.log(dom); // => <a href="#">Link...
    } else {
        
        console.log(error)
    }
});


