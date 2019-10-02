function renderBoolean(data, type, row, meta) {
    return data >= 1 ? "有" : "无";
}

function renderYES(data, type, row, meta) {
    return data >= 1 ? "是" : "<font color='red'>否</font>";
}


function renderPercent0(data, type, row, meta) {
    return accounting.format(data * 100, 0) + '%';
}

function renderPercent1(data, type, row, meta) {
    return accounting.format(data * 100, 1) + '%';
}

function renderPercent2(data, type, row, meta) {
    return (data * 100).toFixed(2) + "%";
}

function renderPercent3(data, type, row, meta) {
    return (data * 100).toFixed(3) + "%";
}

function renderAmount(data, type, row, meta) {
    return accounting.format(data, 2);
}

function renderAmount0(data, type, row, meta) {
    return accounting.format(data);
}

function renderAntiClass(data, type, row, meta) {
    switch (data) {
        case 1:
            return "非限制";
        case 2:
            return "限制";
        case 3:
            return "特殊";
        default :
            if (row['mental'] === 1) return "精神药品";
            else if (row['mental'] === 2) return "糖皮质激素";
            return "";
    }
}

function renderBase2(data, type, row, meta) {
    switch (data) {
        case 1:
            return '基';
        case 2:
            return '国基';
        case 3:
            return '省基';
        default :
            return '';
    }
}

function renderInsurance(data, type, row, meta) {
    if (data === 1) return "甲";
    else if (data === 2) return "乙";
    else return " ";
}

function renderWestern(data, type, row, meta) {
    if (data === 1) return "西药";
    else if (data === 3) return "中成药";
    else if (data === 4) return "中草药";
    else return "";
}

function renderRouter(data, type, row, meta) {
    /* var chn = '';
     for (var bb = 0; bb < routeStore.getCount(); bb++)
         if ((data & routeStore.getAt(bb).get('value')) == routeStore.getAt(bb).get('value')) chn += routeStore.getAt(bb).get('name') + ';';
     return chn.length > 0 ? chn.substring(0, chn.length - 1) : '';*/
}