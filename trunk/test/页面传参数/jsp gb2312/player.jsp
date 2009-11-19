<%@ page contentType="text/html; charset=gb2312" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>无标题文档</title>
<script language="javascript">AC_FL_RunContent = 0;</script>
<script src="AC_RunActiveContent.js" language="javascript"></script>
</head>
<body bgcolor="#999999"  topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0">
<table width="863" height="204" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td><a href="player_para.html?para=<%="你好!"%>">para</a><br/><br/><a href="player_para.jsp?para=<%="你好!"%>">para</a>
    
    
      <form id="form1" name="form1" method="post" action="player_para.jsp">
        <input name="para" type="text" id="para" value="<%="你好!"%>" />
        
            <label>
            <input type="submit" name="button" id="button" value="提交" />
            </label>
      </form>    </td>
  </tr>
</table>
 
</body>
</html>
