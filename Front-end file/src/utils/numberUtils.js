const formatNumber = function (nStr) {
    nStr += '';
    let x = nStr.split('.');
    let x1 = x[0];
    let x2 = x.length > 1 ? '.' + x[1] : '';
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
        x1 = x1.replace(rgx, '$1' + ',' + '$2');
    }
    return x1 + x2;
}
const formatNumberToB = function (nStr) {
    nStr = nStr/10**9
    nStr += '';
    let x = nStr.split('.');
    let x1 = x[0];
    let x2 = x.length > 1 ? '.' + x[1] : '';
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
        x1 = x1.replace(rgx, '$1' + ',' + '$2');
    }
    return x1 + x2 + 'B';
}
const formatNumberToM = function (nStr) {
    nStr = nStr/10**6
    nStr += '';
    let x = nStr.split('.');
    let x1 = x[0];
    let x2 = x.length > 1 ? '.' + x[1] : '';
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
        x1 = x1.replace(rgx, '$1' + ',' + '$2');
    }
    return x1 + x2 + 'M';
}
const formatNumberTo = function (nStr) {
    let sign = ''
    if(nStr/10**9 >= 1){
        nStr = nStr/10**9
        sign = 'B'
    }else if(nStr/10**6 >=1){
        nStr = nStr/10**6
        sign = 'M'
    }else if(nStr/10**3 >=1){
        nStr = nStr/10**3
        sign = 'K'
    }
    nStr += '';
    let x = nStr.split('.');
    let x1 = x[0];
    let x2 = x.length > 1 ? '.' + x[1] : '';
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
        x1 = x1.replace(rgx, '$1' + ',' + '$2');
    }
    return x1 + x2.substr(0,3) + sign;
}
export {
    formatNumber,
    formatNumberToB,
    formatNumberToM,
    formatNumberTo
}
