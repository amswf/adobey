import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class FileSave extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 6620166495688112361L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		saveFile(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		saveFile(request, response);
	}

	private void saveFile(HttpServletRequest request, HttpServletResponse response) {
		int v;

		String saveurl = this.getServletContext().getRealPath("/") + Config.SAVE_FILE_PATH;
		String fileName = request.getParameter("fileName");
		saveurl += fileName; // ±£´æÂ·¾¶
		System.out.println(saveurl);
		BufferedInputStream inputStream;
		try {
			inputStream = new BufferedInputStream(request.getInputStream());
			FileOutputStream outputStream = new FileOutputStream(new File(saveurl));
			byte[] bytes = new byte[1024];
			while ((v = inputStream.read(bytes)) > 0) {
				outputStream.write(bytes, 0, v);
			}
			outputStream.close();
			inputStream.close();

		} catch (IOException e) {

		}
	}
}
