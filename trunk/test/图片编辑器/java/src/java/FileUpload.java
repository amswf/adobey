import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

public class FileUpload extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = -5069049407522655334L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		makeUpdateParam(request);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		makeUpdateParam(request);
	}

	public void makeUpdateParam(HttpServletRequest request) {
		List<FileItem> fileList = new Vector<FileItem>();
		Map<String, String> map = new HashMap<String, String>();
		// 文件上傳部分
		boolean isMultipart = ServletFileUpload.isMultipartContent(request);
		// 得到所有的表单域，它们目前都被当作FileItem
		if (isMultipart == true) {
			try {
				FileItemFactory factory = new DiskFileItemFactory();
				ServletFileUpload upload = new ServletFileUpload(factory);
				// 得到所有的表单域，它们目前都被当作FileItem
				List<FileItem> fileItems = upload.parseRequest(request);
				Iterator<FileItem> iter = fileItems.iterator();
				// 依次处理每个表单域
				while (iter.hasNext()) {
					FileItem item = (FileItem) iter.next();
					String key = item.getFieldName();
					String value = item.getString();
					map.put(key, value);
					if (!item.isFormField()) {
						fileList.add(item);
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			System.out.println("the enctype must be multipart/form-data");
		}
		if (fileList.size() > 0) {
			FileItem item = fileList.get(0);
			String fileNameMD5 = request.getParameter("fileNameMD5");
			if (fileNameMD5 != null) {
				String filePath = this.getServletContext().getRealPath("/") + Config.UPLOAD_FILE_PATH + fileNameMD5;
				File file = new File(filePath);
				try {
					item.write(file);
					System.out.println("filePath:" + filePath);
				} catch (Exception e) {
					System.out.println("fileNameMD5:" + fileNameMD5);
					System.out.println("filePath:" + filePath);
				}
			}
		}
	}
}
