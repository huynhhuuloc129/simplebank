var request = require('request');

var cookieString = 'ZDEDebuggerPresent=php,phtml,php3; PHPSESSID=ji7vlt1d6ks9p0kkktuqm29t4f6tb360'
var cookie = request.cookie(cookieString)

const jsdom = require("jsdom");
const { JSDOM } = jsdom;
global.document = new JSDOM('https://qldt.ctu.edu.vn/htql/dkmh/student/index.php?action=dmuc_mhoc_hky').window.document;

var form = {
cmbHocKy: "1",
cmbNamHoc: "2023",
txtMaMH: "TN002",
curPage: "+",
flag: "1",
Button: "T%C3%ACm",
txtUserID: "",
}

const HocPhan = new Array();

const HP = {
    Kyhieu: "z",
    Thu: "z",
    TietBD: "z",
    Sotiet: "z",
    Phong: "z",
    Siso: "z",
    Sisoconlai: "z",
    Tuanhoc: "z",
    LopHP: "z"
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
        console.log(dom.window.document.body.innerHTML)
        // console.log(response.body); // => <a href="#">Link...
        lv11 = dom.window.document.getElementsByClassName("level_1_1")
        lv12 = dom.window.document.getElementsByClassName("level_1_2")
        i=0;
        j=0;
        

        for (e of lv11){
            i++
            i = i%9
            text = e.innerHTML.replace("&nbsp;", '')
            console.log(text)
            if (text.indexOf("<") == -1){
                switch (i) {    
                    case 0:
                        HP.LopHP = text
                        HocPhan.push(HP)
                        break
                    case 1:
                        HP.Kyhieu = text
                        break
                    case 2:
                        HP.Thu = text
                        break
                    case 3:
                        HP.TietBD = text
                        break
                    case 4:
                        HP.Sotiet = text
                        break
                    case 5:
                        HP.Phong = text
                        break
                    case 6:
                        HP.Siso = text
                        break
                    case 7:
                        HP.Sisoconlai = text
                        break
                    case 8:
                        HP.Tuanhoc = text
                        break
                }
            }
        }

        for (e of lv12){
            j++
        }
        console.log(HocPhan)
    } else {
        
        console.log(error)
    }
});


