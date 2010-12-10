
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%
	int v;

	String url = "admin/save/"; //应保证在根目录中有此目录的存在
	String saveurl = application.getRealPath("/") + url;
	String fileName = request.getParameter("fileName");
	saveurl += fileName; //保存路径
	System.out.println(saveurl);
	BufferedInputStream inputStream = new BufferedInputStream(request.getInputStream());
	FileOutputStream outputStream = new FileOutputStream(new File(saveurl));
	byte[] bytes = new byte[1024];
	while ((v = inputStream.read(bytes)) > 0) {
		outputStream.write(bytes, 0, v);
	}
	outputStream.close();
	inputStream.close();
%>
