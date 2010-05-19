var SnJsckForm = function(formId) {
	var formId = formId;
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
	var CHECK_FORMAT_DEFAULT_VALUE = '#';// #代表任意位，0代表1位 ：#.# 00.00 00.# #.00
	// 等组合
	// 标准标签
	var ELE_ATTR_VALUE = 'value';
	var ELE_ATTR_MAX_LENGTH = 'maxlength';
	var ELE_ATTR_TYPE = 'type';

	// 辅助标签
	var ELE_ATTR_MIN_LENGTH = 'minlength';
	var ELE_ATTR_CHECK_TYPE = 'checktype';
	var ELE_ATTR_CHECK_FORMAT = 'checkformat';
	var ELE_ATTR_CHECK_MSG = 'checkmsg';
	var ELE_ATTR_CHECK_FUN = 'checkfun';

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
	this.snCheck = function() {

		var form = document.getElementById(formId);
		if (form != null) {
			var allEle = new Array();
			allEle = getAllElements(form);
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
	this.addEventCheckElements = function() {
		initBaseDiv();
		var form = document.getElementById(formId);
		if (form != null) {
			var allEle = new Array();
			allEle = getAllElements(form);
			for (var i = 0; i < allEle.length; i++) {
				var ele = allEle[i];

				if (window.addEventListener) {
					ele.addEventListener('change', handlerElementEventOnblur,
							false);
				}
				else if (window.attachEvent) {
					ele.attachEvent('onchange', handlerElementEventOnblur);
				}
				else {
					ele.onchange = handlerElementEventOnblur;
				}
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
	function handlerElementEventOnblur(e) {
		var aele = null;
		if (window.event) {
			aele = window.event.srcElement;
		}

		else {
			aele = e.target;
		}
		var ele = getNowDocumentElement(aele);
		if (ele != null) {
			var sign = true;
			setInterval(function() {
						if (sign) {
							sign = false;
							checkElement(ele);
						}
					}, 0);
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
			var ele = getElementInForm(formId, aele.id);
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
		var ff = document.getElementById('fileField').value;
		var nele = getNowDocumentElement(ele);
		var minlenStr = getElementAttribute(nele, ELE_ATTR_MIN_LENGTH,
				MIN_LENGTH_DEFAULT_VALUE);
		var maxlenStr = getElementAttribute(nele, ELE_ATTR_MAX_LENGTH,
				MAX_LENGTH_DEFAULT_VALUE);
		var ctypeStr = getElementAttribute(nele, ELE_ATTR_CHECK_TYPE,
				CHECK_TYPE_DEFAULT);
		var cfmtStr = getElementAttribute(nele, ELE_ATTR_CHECK_FORMAT,
				CHECK_FORMAT_DEFAULT_VALUE);
		var cmsgStr = getElementAttribute(nele, ELE_ATTR_CHECK_MSG,
				CHECK_MSG_DEFAULT_VALUE);
		var eleValueStr = getElementValue(nele, '');
		var checkfunStr = getElementAttribute(nele, ELE_ATTR_CHECK_FUN, '');
		var sign = true;
		var ctypeIsEffective = false;
		if (ctypeStr != null && ctypeStr.length > 0) {
			if (ctypeStr == CHECK_TYPE_TEXT) {
				ctypeIsEffective = true;
				var minlen = parseInt(minlenStr);
				var maxlen = parseInt(maxlenStr);
				var eleValueLen = -1;
				if (eleValueStr != null && eleValueStr.length > 0) {
					var trimStr = checkCTrim(eleValueStr, 0);
					eleValueLen = checkTextLength(trimStr);
				}
				if (!isNaN(minlen) && minlen >= 0) {
					if (eleValueLen < minlen) {
						alertMsg(nele, cmsgStr + "　:" + "长度不能小于" + minlen);
						sign = sign && false;
					}
				}
				else if (!isNaN(maxlen) && maxlen >= 0) {
					if (eleValueLen > maxlen) {
						alertMsg(nele, cmsgStr + "　:" + "长度不能大于" + maxlen);
						sign = sign && false;
					}
				}

			}
			else if (ctypeStr == CHECK_TYPE_NUM) {
				ctypeIsEffective = true;
				if (!checkFormatValue(cfmtStr, eleValueStr)) {
					alertMsg(nele, cmsgStr + "　:" + "数字格式应为" + cfmtStr);
					sign = sign && false;
				}

			}

			if (ctypeIsEffective) {
				if (checkfunStr.length > 0) {
					var cb = callBack(nele, checkfunStr);
					sign = sign && cb;
				}
			}
		}

		if (sign) {
			var msgdivStr = getElementAttribute(ele, 'msgdiv', null);
			if (msgdivStr != null && msgdivStr.length > 0) {
				var divEle = document.getElementById(msgdivStr);
				divEle.style.display = 'none';
			}
		}
		return sign;
	}

	/**
	 * 
	 * @param {}
	 *            ele
	 * @param {}
	 *            functionName
	 */
	function callBack(ele, functionName) {
		var nele = getNowDocumentElement(ele);
		if (nele != null && functionName != null && functionName.length > 0) {
			try {
				return eval(functionName + '(nele)');
			}
			catch (e) {
			}
		}
		return true;
	}

	/**
	 * 
	 * @param {}
	 *            ele
	 * @param {}
	 *            msg
	 */
	function alertMsg(ele, msg) {
		creatMsgDiv(ele, msg);
	}

	/**
	 * 
	 * @param {}
	 *            cfmtStr
	 * @param {}
	 *            value
	 * @return {Boolean}
	 */
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
	function getElementValue(ele, defValue) {
		var attrStr = null;
		try {
			attrStr = ele.value;
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
				var eleIdStr = getElementAttribute(ele, 'id', null);
				if (eleIdStr != null && eleIdStr.length > 0) {
					if (tagIdAry[eleIdStr] == null) {
						tagIdAry[eleIdStr] = eleIdStr;
						allEleAry.push(ele);
					}
					else {
						alert("jsck: 表单项id有重复项，出错表单项id为 " + eleIdStr);
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
	 */
	function initBaseDiv() {
		var divSnjsck = document.getElementById('snjsck');
		var divSnjsckFormHTML = '';
		var formsAry = document.getElementsByTagName('form');
		var jsckDiv = document.getElementById('snjsck');
		var childAry = null;
		if (jsckDiv != null) {
			childAry = jsckDiv.getElementsByTagName('div');
		}
		var childNameAry = new Array();
		if (childAry != null) {
			for (var i = 0; i < childAry.length; i++) {
				var child = childAry[i];
				var cid = child.id;
				if (cid != null && cid.length > 0) {
					childNameAry[cid] = cid;
				}
			}
		}
		var ary = new Array();
		for (var i = 0; i < formsAry.length; i++) {
			var form = formsAry[i];
			var formId = form.id;
			var formDivId = 'snjsck_' + formId;
			var sign = false;
			if (jsckDiv != null) {
				if (childNameAry[formDivId] != null) {
					sign = true;
				}
			}

			if (!(sign)) {
				if (formId != null && formId.length > 0) {
					if (ary[formId] == null) {
						ary[formId] = formId;
						divSnjsckFormHTML += '<div id=\"' + formDivId
								+ '\"></div>';
					}
					else {
						alert('jsck:form id 有重复!');
					}
				}
			}
		}

		if (jsckDiv == null) {
			document.body.innerHTML += '<div id=\"snjsck\">'
					+ divSnjsckFormHTML + '</div>';
		}
		else {
			jsckDiv.innerHTML += divSnjsckFormHTML;
		}
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
		var msgdivStr = getElementAttribute(ele, 'msgdiv', null);
		var divIdStr = '';
		if (msgdivStr == null || msgdivStr.length == 0) {
			var eleIdStr = getElementAttribute(ele, 'id', 'ele');
			divIdStr = eleIdStr + '_msg_div';
			divIdStr = creatMsgDivIdStr(divIdStr);

			var left = getAbsoluteLeft(ele) + ele.offsetWidth;
			var top = getAbsoluteTop(ele);
			var divStr = '<div id=\"' + divIdStr
					+ '\" class=\"msgdiv\" style=\" left: ' + left
					+ 'px; top: ' + top + 'px;\">' + msg + '</div>';

			if (document.body != null) {
				document.getElementById('snjsck_' + formId).innerHTML += divStr;
			}
			var nele = getNowDocumentElement(ele);
			nele.setAttribute('msgdiv', divIdStr);
		}
		else {
			if (msgdivStr != null && msgdivStr.length > 0) {
				var divEle = document.getElementById(msgdivStr);
				divEle.innerHTML = msg;
				divEle.style.display = '';
			}
		}
		return divIdStr;

	}

	/**
	 * 
	 * @param {Object}
	 *            formId
	 * @param {Object}
	 *            eleId
	 */
	function getElementInForm(formId, eleId) {
		var ele = null;
		if (formId != null && formId.length > 0) {
			var form = document.forms[formId];
			if (form != null) {
				if (eleId != null && eleId.length > 0) {
					ele = form.elements[eleId];

				}
			}
		}
		return ele;
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

	function checkTextLength(text) {
		return (text.replace(/[^\x00-\xff]/g, "aa")).length;
	}

	/**
	 * 1=去掉字符串左边的空格 2=去掉字符串左边的空格 0=去掉字符串左边和右边的空格 return
	 * 
	 * @param {}
	 *            sInputString
	 * @param {}
	 *            iType
	 * @return {}
	 */
	function checkCTrim(sInputString, iType) {
		var sTmpStr = ' ';
		var i = -1;
		if (iType == 0 || iType == 1) {
			while (sTmpStr == ' ') {
				++i;
				sTmpStr = sInputString.substr(i, 1);
			}
			sInputString = sInputString.substring(i);
		}
		if (iType == 0 || iType == 2) {
			sTmpStr = ' ';
			i = sInputString.length;
			while (sTmpStr == ' ') {
				--i;
				sTmpStr = sInputString.substr(i, 1);
			}
			sInputString = sInputString.substring(0, i + 1);
		}
		return sInputString;
	}
}
