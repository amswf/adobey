<%@ page contentType="text/html; charset=gb2312" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>无标题文档</title>
<script language="javascript">AC_FL_RunContent = 0;</script>
<script src="AC_RunActiveContent.js" language="javascript"></script>
</head>
<%
//                       gb2312          iso_8859_1

String str = request.getParameter("para");
//str = new String(str.getBytes("iso_8859_1"), "utf-8");
str = new String(str.getBytes("iso_8859_1"), "gb2312");
%>
<body bgcolor="#999999"  topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0">
<!--影片中使用的 URL-->
<!--影片中使用的文本-->
<!-- saved from url=(0013)about:internet -->
<script language="javascript">
	//para = 'htmltxt='+window.location.href.split("vn=")[1];
	para = 'htmltxt=<%=str%>';
	if (AC_FL_RunContent == 0) {
	alert("此页需要 AC_RunActiveContent.js");
	} else {
		AC_FL_RunContent(
			'codebase', 'http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0',
			'width', '400',
			'height', '300',
			'src', 'player?'+para,
			'flashvars',para,
			'quality', 'high',
			'pluginspage', 'http://www.macromedia.com/go/getflashplayer',
			'align', 'middle',
			'play', 'true',
			'loop', 'true',
			'scale', 'showall',
			'wmode', 'window',
			'devicefont', 'false',
			'id', 'player',
			'bgcolor', '#999999',
			'name', 'player',
			'menu', 'false',
			'allowFullScreen', 'true',
			'allowScriptAccess','sameDomain',
			'movie', 'player?'+para,
			'salign', ''
			); //end AC code
	}
</script>
</body>
</html>
