
// 表单项标签类型
var chkNames = new Array();
chkNames.push('input');
chkNames.push('textarea');
chkNames.push('select');

// input类型
var inputType = new Array();
inputType.push('file');
inputType.push('text');
inputType.push('checkbox');
inputType.push('radio');

// 验证类型
var CHECK_TYPE_TEXT = 'text';
var CHECK_TYPE_NUM = 'num';// 和CHECK_FORMAT_DEFAULT 组合验证小数
var CHECK_TYPE_DATE = 'date';

var CHECK_TYPE_DEFAULT = CHECK_TYPE_TEXT;

// 验证格式
var CHECK_FORMAT_DEFAULT_VALUE = '#';// #代表任意位，0代表1位 ：#.# 00.00 00.# #.00 等组合
// 标准标签
var ELE_ATTR_VALUE = 'value';
var ELE_ATTR_MAX_LENGTH = 'maxlength';
var ELE_ATTR_TYPE = 'type';

// 辅助标签
var ELE_ATTR_MIN_LENGTH = 'minlength';
var ELE_ATTR_CHECK_TYPE = 'checktype';
var ELE_ATTR_CHECK_FORMAT = 'checkformat';
var ELE_ATTR_CHECK_MSG = 'checkmsg';

var MIN_LENGTH_DEFAULT_VALUE = '-1';
var MAX_LENGTH_DEFAULT_VALUE = '-1';
var CHECK_MSG_DEFAULT_VALUE = '验证失败!';
var TYPE_VALUE_FILE = 'file';

/**
 * 主调方法
 * 
 * @param {}
 *            formId
 */
function snCheck(formId) {
	var form = document.getElementById(formId);
	if (form != null) {
		var allEle = new Array();
		allEle = getAllElements(form);
		// alert(allEle.length);
		for (var i = 0; i < allEle.length; i++) {
			var ele = allEle[i];
			var check = checkElement(ele);
			if (!check) {
				return false;
			}
		}
		return true;
	}
	else {
		alert('找不到id为:' + formId + '的form');
	}
}

/**
 * 
 * @param {Object}
 *            formId
 */
function addEventCheckElements(formId) {
	var form = document.getElementById(formId);
	if (form != null) {
		var allEle = new Array();
		allEle = getAllElements(form);
		for (var i = 0; i < allEle.length; i++) {
			var ele = allEle[i];
			ele.setAttribute('onblur', 'handlerElementEventOnblur();');
		}
	}
	else {
		alert('找不到id为:' + formId + '的form');
	}
}

/**
 * 
 * @param {}
 *            ele
 */
function handlerElementEventOnblur() {
	var aele = window.event.srcElement;

	var ele = getNowDocumentElement(aele);

	if (ele != null) {
		checkElement(ele);
	}
}

/**
 * *
 * 
 * @param {}
 *            aele
 * @return {}
 */
function getNowDocumentElement(aele) {
	if (aele.id != null && aele.id.length > 0) {
		var ele = document.getElementById(aele.id);
		return ele;
	}
	return null;
}

/**
 * 
 * @param {}
 *            ele
 * @return {Boolean}
 */
function checkElement(ele) {
	var minlenStr = getElementAttribute(ele, ELE_ATTR_MIN_LENGTH,
			MIN_LENGTH_DEFAULT_VALUE);
	var maxlenStr = getElementAttribute(ele, ELE_ATTR_MAX_LENGTH,
			MAX_LENGTH_DEFAULT_VALUE);
	var ctypeStr = getElementAttribute(ele, ELE_ATTR_CHECK_TYPE,
			CHECK_TYPE_DEFAULT);
	var cfmtStr = getElementAttribute(ele, ELE_ATTR_CHECK_FORMAT,
			CHECK_FORMAT_DEFAULT_VALUE);
	var cmsgStr = getElementAttribute(ele, ELE_ATTR_CHECK_MSG,
			CHECK_MSG_DEFAULT_VALUE);
	var eleValueStr = getElementAttribute(ele, ELE_ATTR_VALUE, '');

	if (ctypeStr != null && ctypeStr.length > 0) {
		if (ctypeStr == CHECK_TYPE_TEXT) {
			var minlen = parseInt(minlenStr);
			var maxlen = parseInt(maxlenStr);
			if (!isNaN(minlen) && minlen >= 0) {
				if (eleValueStr.length < minlen) {
					alertMsg(ele, cmsgStr + "　:" + "长度不能小于" + minlen);
					return false;
				}
			}

			if (!isNaN(maxlen) && maxlen >= 0) {
				if (eleValueStr.length > maxlen) {
					alertMsg(ele, cmsgStr + "　:" + "长度不能大于" + maxlen);
					return false;
				}
			}
		}
		else if (ctypeStr == CHECK_TYPE_NUM) {
			if (!checkFormatValue(cfmtStr, eleValueStr)) {
				alertMsg(ele, cmsgStr + "　:" + "数字格式应为" + cfmtStr);
				return false;
			}
		}
	}

	var msgdivStr = getElementAttribute(ele, 'msgdiv', null);
	if (msgdivStr != null && msgdivStr.length > 0) {
		var divEle = document.getElementById(msgdivStr);
		divEle.style.display = 'none';
	}
	return true;
}

function alertMsg(ele, msg) {
	creatMsgDiv(ele, msg);
}

function checkFormatValue(cfmtStr, value) {
	// var cfmtStr = '';//删除本行
	var ary = new Array();
	ary = cfmtStr.split('.');

	var leftlen = -1;
	var rightlen = -1;

	if (ary.length >= 2) {
		var leftStr = ''
		leftStr = ary[0];
		if (leftStr != null) {
			if (leftStr.indexOf('#') >= 0) {
				leftlen = -1;
			}
			else {
				leftlen = leftStr.length;
			}
		}
		var rightStr = ''
		rightStr = ary[1];
		if (rightStr != null) {
			if (rightStr.indexOf('#') >= 0) {
				rightlen = -1;
			}
			else {
				rightlen = rightStr.length;
			}
		}
		if (checkNum(value, leftlen, rightlen)) {
			return true;
		}
	}
	return false;
}

/**
 * 
 * @param {}
 *            value 值
 * @param {}
 *            leftlen 整数部分长度
 * @param {}
 *            rightlen 小数部分长度
 * @return {Boolean}
 */
function checkNum(value, leftlen, rightlen) {
	var pa = '^\\d{0,' + leftlen + '}.\\d{0,' + rightlen + '}$';
	var re = new RegExp(pa);
	if (re.test(value)) {
		return true;
	}
	return false;
}

/**
 * 获得结点属性
 * 
 * @param {}
 *            ele 结点
 * @param {}
 *            attrName 属性
 * @param {}
 *            defValue 默认置
 * @return {} 结点属性值
 */
function getElementAttribute(ele, attrName, defValue) {
	var attrStr = null;
	try {
		attrStr = ele.getAttribute(attrName);
	}
	catch (e) {
	}
	if (attrStr == null) {
		attrStr = defValue;
	}

	return attrStr;
}

/**
 * 获得结点下的全部验证结点
 * 
 * @param {}
 *            docObj 文档对象
 * @return {} 结点列表
 */
function getAllElements(docObj) {
	var allEleAry = new Array();
	var tagIdAry = new Array();
	for (var i = 0; i < chkNames.length; i++) {
		var name = '';
		name = chkNames[i];
		var ary = new Array();
		ary = docObj.getElementsByTagName(name);
		for (var j = 0; j < ary.length; j++) {
			var ele = ary[j];
			var eleIdStr = this.getElementAttribute(ele, 'id', null);
			if (eleIdStr != null && eleIdStr.length > 0) {
				if (tagIdAry[eleIdStr] == null) {
					tagIdAry[eleIdStr] = eleIdStr;
					allEleAry.push(ele);
				}
				else {
					alert("表单项id有重复项，出错表单项id为：" + eleIdStr);
				}
			}
		}
	}
	return allEleAry;
}

/**
 * 
 * @param {}
 *            obj
 * @return {}
 */
getAbsoluteLeft = function(obj) {
	// 获取指定元素左上角的横坐标（相对于body）
	/*
	 * obj | 指定的元素对象
	 */
	var selfLeft = 0;
	var element = obj;
	while (element) {
		selfLeft = selfLeft + element.offsetLeft;
		element = element.offsetParent;
	};
	return selfLeft;
}

/**
 * 
 * @param {}
 *            obj
 * @return {}
 */
getAbsoluteTop = function(obj) {
	// 获取指定元素左上角的纵坐标（相对于body）
	/*
	 * obj | 指定的元素对象
	 */
	var selfTop = 0
	var element = obj;
	while (element) {
		selfTop = selfTop + element.offsetTop;
		element = element.offsetParent;
	};
	return selfTop;
}

/**
 * 
 * @param {}
 *            ele
 * @param {}
 *            msg
 * @return {}
 */
function creatMsgDiv(ele, msg) {
	// var ele = getNowDocumentElement(aele);
	var msgdivStr = getElementAttribute(ele, 'msgdiv', null);
	var divIdStr = '';
	if (msgdivStr == null || msgdivStr.length == 0) {
		var eleIdStr = getElementAttribute(ele, 'id', 'ele');
		divIdStr = eleIdStr + '_msg_div';
		divIdStr = creatMsgDivIdStr(divIdStr);

		var left = getAbsoluteLeft(ele) + ele.offsetWidth;
		var top = getAbsoluteTop(ele);
		var divStr = '<div id=\"' + divIdStr + '\" class=\"msgdiv\" style=\" left: ' + left
				+ 'px; top: ' + top + 'px;\">' + msg + '</div>';

		if (document.body != null) {
			document.body.innerHTML += divStr;
		}
		var nele = getNowDocumentElement(ele);
		nele.setAttribute('msgdiv', divIdStr);
	}
	else {
		if (msgdivStr != null && msgdivStr.length > 0) {
			var divEle = document.getElementById(msgdivStr);
			divEle.style.display = '';
		}
	}
	return divIdStr;

}

/**
 * 创建div id 查询有重的尾号加1
 * 
 * @param {}
 *            str
 * @return {}
 */
function creatMsgDivIdStr(str) {
	var i = 0;
	var rstr = str + '_';
	while (document.getElementById(rstr + i) != null) {
		i++;
	}
	return rstr + i;
}
