var request = require('request');

var cookieString = 'ZDEDebuggerPresent=php,phtml,php3; PHPSESSID=ji7vlt1d6ks9p0kkktuqm29t4f6tb360'
var cookie = request.cookie(cookieString)


const tesseract = require("node-tesseract-ocr")

const config = {
  lang: "eng",
  oem: 1,
  psm: 3,
}

const img = "https://htql.ctu.edu.vn/htql/capcha/securimage_show.php?sid=0.6427769930412555"

tesseract
  .recognize(img, config)
  .then((text) => {
    console.log("Result:", text)
  })
  .catch((error) => {
    console.log(error.message)
  })



const jsdom = require("jsdom");
const { JSDOM } = jsdom;

global.document = new JSDOM('https://qldt.ctu.edu.vn/htql/dkmh/student/index.php?action=dmuc_mhoc_hky').window.document;

const today = new Date()
const month = today.getMonth()
var hocky
if (month <10 && month >=6) {
    hocky = 1
} else if (month >=10 && month<=4){
    hocky = 2
} else hocky = 3


var form = {
cmbHocKy: hocky,
cmbNamHoc: today.getFullYear(),
txtMaMH: "TC025",
curPage: "+",
flag: "1",
Button: "T%C3%ACm",
txtUserID: "",
}

const HocPhan = new Array();
const HP = {
    Kyhieu: "",
    Thu: "",
    TietBD: "",
    Sotiet: "",
    Phong: "",
    Siso: "",
    Sisoconlai: "",
    Tuanhoc: "",
    LopHP: ""
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
        
        lv11 = dom.window.document.getElementsByClassName("level_1_1")
        lv12 = dom.window.document.getElementsByClassName("level_1_2")
        i=0;
        j=0;

        for (e of lv11){
            i++
            i = i%9
            text = e.innerHTML.replace("&nbsp;", '')
            if (text.indexOf("<") == -1){
                switch (i) {    
                    case 0:
                        HP.LopHP = text
                        HP1 = JSON.parse(JSON.stringify(HP))
                        HocPhan.push(HP1)
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
        for (k of lv12){
            j++
            j = j%9
            text = k.innerHTML.replace("&nbsp;", '')
            if (text.indexOf("<") == -1){
                switch (j) {    
                    case 0:
                        HP.LopHP = text
                        HP1 = JSON.parse(JSON.stringify(HP))
                        HocPhan.push(HP1)
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
        console.log(HocPhan)
        console.log(HocPhan.length)
    } else {
        console.log(error)
    }
});


