<%@ page contentType="text/html;charset=gb2312" language="java"
	import="java.io.*,java.awt.Image,java.awt.image.*,com.sun.image.codec.jpeg.*,java.sql.*,com.jspsmart.upload.*,java.util.*"%>
<%
	String fileNameMD5 = request.getParameter("fileNameMD5");
	System.out.println(fileNameMD5);
	SmartUpload mySmartUpload = new SmartUpload();
	long file_size_max = 4000000;
	String fileName2 = "", ext = "", testvar = "";
	String url = "admin/upload/"; //Ӧ��֤�ڸ�Ŀ¼���д�Ŀ¼�Ĵ���
	//��ʼ��
	mySmartUpload.initialize(pageContext);
	//ֻ�������ش����ļ�
	try {
		mySmartUpload.setAllowedFilesList("jpg,gif,png");
		//�����ļ� 
		mySmartUpload.upload();
	} catch (Exception e) {

	}
	try {

		com.jspsmart.upload.File myFile = mySmartUpload.getFiles().getFile(0);
		if (myFile.isMissing()) {

		} else {
			//String myFileName=myFile.getFileName(); //ȡ�����ص��ļ����ļ���
			ext = myFile.getFileExt(); //ȡ�ú�׺��
			int file_size = myFile.getSize(); //ȡ���ļ��Ĵ�С 
			String saveurl = "";
			if (file_size < file_size_max) {
				//�����ļ�����ȡ�õ�ǰ�ϴ�ʱ��ĺ�����ֵ
				Calendar calendar = Calendar.getInstance();
				String filename = null;
				if(fileNameMD5 != null){
					filename = fileNameMD5;
					
				}
				else {
					filename = String.valueOf(calendar.getTimeInMillis());
				}
				saveurl = application.getRealPath("/") + url;
				saveurl += filename + "." + ext; //����·��
				System.out.println(saveurl);
				myFile.saveAs(saveurl, SmartUpload.SAVE_PHYSICAL);
				String ret = "parent.HtmlEdit.focus();";
				ret += "var range = parent.HtmlEdit.document.selection.createRange();";
				ret += "range.pasteHTML('<img src=\"" + request.getContextPath() + "/admin/upload/" + filename + "." + ext + "\">');";
				ret += "alert('�ϴ��ɹ���');";
				ret += "window.location='upload.htm';";
				out.print("<script language=javascript>" + ret + "</script>");

			}
		}
	} catch (Exception e) {
		out.print(e.toString());
	}
%>

