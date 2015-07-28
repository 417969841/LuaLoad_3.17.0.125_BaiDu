package com.tongqu.client.utils.res;

import java.io.DataOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import org.apache.http.Header;
import org.apache.http.message.BasicHeader;

import android.content.Context;
import android.os.Handler;

public class HttpEngine {
	public static final int MY_NOTIFICATION_ID = 0x100;

	static HttpEngine m_engine = null;

	HttpThread m_httpThread = null;
	private boolean m_isReturnHeader = false;
	private Header[] headers;
	public static String X_SID;
	public static String X_EXPIRED;// session过期时间;
	public static long LAST_HTTPTIME;
	private String username;

	// private String host = "";
	// private byte[] databytes;
	// private String realurl;

	public static HttpEngine getHttpEngine() {
		if (m_engine == null) {
			m_engine = new HttpEngine();
		}
		return m_engine;
	}

	public void begineGet(String URL, Handler handler, Context context) {

		headers = new Header[1];
		headers[0] = new BasicHeader("Accept-Encoding", "gzip;q=1.0,identity;q=0.8");

		m_httpThread = new HttpThread();
		m_httpThread.setReturnHeader(this.m_isReturnHeader);
		m_isReturnHeader = false;
		m_httpThread.connect(context, URL, handler, null, headers);
	}

	// HttpEngine.getHttpEngine().begineGet(lastTask.getUrl(),
	// lastTask.getMsgwhat(), handler, lastTask.getContext(),
	// lastTask.getFunengid());
	public void begineGet(String URL, int command, Handler handler, Context context, boolean isshowprogress) {

		headers = new Header[1];
		headers[0] = new BasicHeader("Accept-Encoding", "gzip;q=1.0,identity;q=0.8");

		m_httpThread = new HttpThread();
		m_httpThread.setReturnHeader(this.m_isReturnHeader);
		m_httpThread.setIsShowProgress(isshowprogress);
		m_isReturnHeader = false;
		m_httpThread.connect(context, URL, handler, null, headers);
	}

	public void beginePost(String URL, byte[] data, int command, Handler handler, Context context, boolean isshowprogress) {
		headers = new Header[1];
		headers[0] = new BasicHeader("Accept-Encoding", "gzip;q=1.0,identity;q=0.8");

		m_httpThread = new HttpThread();
		m_httpThread.setReturnHeader(this.m_isReturnHeader);
		m_httpThread.setIsShowProgress(isshowprogress);
		m_isReturnHeader = false;
		m_httpThread.connect(context, URL, handler, data, headers);
	}

	public void cancel() {
		m_httpThread.cancel();
	}

	public void setReturnHeader() {
		m_isReturnHeader = true;
	}

	/**
	 * 上传文件到服务器
	 * 
	 * @param actionUrl
	 * @param uploadFile
	 */
	public boolean uploadFile(String actionUrl, InputStream fStream, String newName) {
		String end = "\r\n";
		String twoHyphens = "--";
		String boundary = "---------------------------41184676334";
		try {
			URL url = new URL(actionUrl);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			/* 允许Input、Output，不使用Cache */
			con.setDoInput(true);
			con.setDoOutput(true);
			con.setUseCaches(false);
			/* 设置传送的method=POST */
			con.setRequestMethod("POST");
			/* setRequestProperty */
			con.setRequestProperty("Connection", "Keep-Alive");
			con.setRequestProperty("Charset", "UTF-8");
			con.setRequestProperty("Content-Type", "multipart/form-data;boundary=" + boundary);
			/* 设置DataOutputStream */
			DataOutputStream ds = new DataOutputStream(con.getOutputStream());
			ds.writeBytes(twoHyphens + boundary + end);
			ds.writeBytes("Content-Disposition: form-data; " + "name=\"photo\";filename=\"" + newName + ".jpg\"\r\nContent-Type: image/jpeg" + end);
			ds.writeBytes(end);
			/* 取得文件的FileInputStream */
			// FileInputStream fStream = new FileInputStream(uploadFile);
			/* 设置每次写入1024bytes */
			int bufferSize = 10240;
			byte[] buffer = new byte[bufferSize];
			int length = -1;
			/* 从文件读取数据至缓冲区 */
			while ((length = fStream.read(buffer)) != -1) {
				/* 将资料写入DataOutputStream中 */
				ds.write(buffer, 0, length);
			}
			ds.writeBytes(end);
			ds.writeBytes(twoHyphens + boundary + twoHyphens + end);
			/* close streams */
			fStream.close();
			ds.flush();
			/* 取得Response内容 */
			InputStream is = con.getInputStream();
			int ch;
			StringBuffer b = new StringBuffer();
			while ((ch = is.read()) != -1) {
				b.append((char) ch);
			}
			ds.close();
			return true;
		} catch (Exception e) {
			return false;
		}
	}
}
