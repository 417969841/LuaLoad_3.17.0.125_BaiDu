package com.tongqu.client.utils.res;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.zip.GZIPInputStream;

import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.HttpHost;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.params.ConnRoutePNames;
import org.apache.http.entity.ByteArrayEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;

import android.content.Context;
import android.net.wifi.WifiManager;
import android.os.Handler;
import android.os.Message;

public class HttpThread {
	private HttpClient m_client = null;
	private int conetStyle;
	private boolean m_iscanceled = false;
	private boolean m_isReturnHeader = false;
	private boolean m_isShowProgress = false;
	public static int getStyle = 0;
	public static int postStyle = 1;

	// public static String x_sid="";
	// private String x_sid="";
	// private Thread thistread=null;
	String strURL = null;
	Handler m_handler = null;
	Context m_context = null;
	private static final int MAXCONNEXTNUM = 3;

	public void setReturnHeader(boolean b) {
		m_isReturnHeader = b;
	}

	public void setIsShowProgress(boolean isShow) {
		m_isShowProgress = isShow;
	}

	private String getProxy() {
		String proxyStr = "";
		try {
			WifiManager wifiManager = (WifiManager) m_context.getSystemService(Context.WIFI_SERVICE);
			if (!wifiManager.isWifiEnabled()) {
				proxyStr = android.net.Proxy.getDefaultHost();
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return proxyStr;
	}

	public void connect(Context context, final String URL, final Handler handler, final byte[] data, final Header[] headers) {
		m_context = context;
		if (data == null)
			conetStyle = getStyle;
		else
			conetStyle = postStyle;
		if (m_isShowProgress) {
			
		}
		new Thread() {
			byte[] bt1;
			Object[] retobj = new Object[2];

			public void run() {
				strURL = URL;
				m_handler = handler;
				String m_host = null, m_short_url = null;
				if (strURL != null)
					strURL = strURL.trim();
				int pos1 = strURL.indexOf("http://");
				if (pos1 == 0) {
					String str = strURL.substring(pos1 + 7);
					int pos2 = str.indexOf("/");
					if (pos2 >= 0) {
						m_host = str.substring(0, pos2);
						m_short_url = str.substring(pos2);
					} else {
						m_host = str;
						m_short_url = "";
					}
				} else {
					return;
				}
				int connectNum = 0;
				while (true) {
					connectNum++;
					if (connectNum > MAXCONNEXTNUM) {
						Message mg = Message.obtain();
						mg.getData().putString("URL", URL);
						mg.obj = "exception!网络有误，请确认网络设置正确或稍后重试" + URL;
						mg.getData().putBoolean("wrongurl", true);
						// mg.arg1=m_command;
						if (m_handler != null)
							m_handler.sendMessage(mg);
						break;
					}
					try {
						HttpParams httpParams = new BasicHttpParams();
						HttpConnectionParams.setConnectionTimeout(httpParams, 30000);
						HttpConnectionParams.setSoTimeout(httpParams, 30000);

						m_client = new DefaultHttpClient(httpParams);
						String conUrl = "";
						String proxy = getProxy();
						if (proxy != null && proxy.length() > 0) {
							HttpHost httpproxy = new HttpHost(proxy, 80);
							m_client.getParams().setParameter(ConnRoutePNames.DEFAULT_PROXY, httpproxy);
						}
						String temHost = "";
						temHost = m_host;
						conUrl = "http://" + temHost + m_short_url;
						HttpGet get = null;
						HttpPost post = null;
						if (conetStyle == getStyle) {
							get = new HttpGet(conUrl);
							get.setHeaders(headers);

							if (proxy != null && proxy.length() > 0) {
								get.setHeader("X-Online-Host", temHost + ":80");
							}
						} else {
							post = new HttpPost(conUrl);
							post.setHeaders(headers);

							if (proxy != null && proxy.length() > 0) {
								post.setHeader("X-Online-Host", temHost + ":80");
							}
							ByteArrayEntity entity = new ByteArrayEntity(data);
							entity.setContentType("application/octet-stream");
							post.setEntity(entity);
						}
						HttpResponse response;
						if (conetStyle == getStyle) {
							response = m_client.execute(get);
						} else {
							response = m_client.execute(post);
						}

						if (response.getStatusLine().getStatusCode() != HttpStatus.SC_OK && response.getStatusLine().getStatusCode() != HttpStatus.SC_PARTIAL_CONTENT) {

							if (m_iscanceled) {
								return;
							}
							if (connectNum >= MAXCONNEXTNUM) {
								Message mg = Message.obtain();
								mg.getData().putString("URL", URL);
								mg.obj = "资源获取失败：" + URL;
								// mg.arg1=m_command;
								mg.getData().putBoolean("wrongurl", true);
								if (m_handler != null)
									m_handler.sendMessage(mg);
								if (conetStyle == getStyle)
									get.abort();
								else
									post.abort();
								if (m_client != null) {
									m_client.getConnectionManager().shutdown();// 断掉连接
								}
								break;
							} else {
								continue;
							}
						} else {
							Header[] heads = response.getHeaders("Content-Type");
							if (heads != null && heads.length > 0)

							{
								String ct = heads[0].getValue();
								if (ct != null && (ct.indexOf("text/vnd.wap.wml") >= 0 || ct.indexOf("application/vnd.wap.wmlc") >= 0)) {
									continue;
								}
							}
							HttpEntity entity = response.getEntity();
							long length = entity.getContentLength();
							InputStream is = entity.getContent();
							Message mg = null;

							String ifGizp = "";
							heads = response.getHeaders("Content-Encoding");
							if (heads != null && heads.length > 0)
								ifGizp = heads[0].getValue();
							boolean gizp = false;
							if (ifGizp != null && ifGizp.toLowerCase().indexOf("gzip") != -1) {
								gizp = true;
							}
							if (is != null) {
								ByteArrayOutputStream baos = new ByteArrayOutputStream();
								byte[] buf = new byte[1024];
								int ch = -1;
								int count = 0;
								while ((ch = is.read(buf)) != -1) {
									baos.write(buf, 0, ch);// 下载的内容不要超过3m，如果超过则直接向文件中写内容。
									count += ch;
									// outStream.write(buf, 0, ch);
									float num = (float) count / (float) length;
									//
									// mg = Message.obtain();
									// mg.getData().putFloat("percent", num);
									// mg.getData().putBoolean("done", false);
									// if (m_handler != null)
									// m_handler.sendMessage(mg);
								}
								if (gizp) {
									ByteArrayInputStream byteStream = new ByteArrayInputStream(baos.toByteArray());
									InputStream inStream = new GZIPInputStream(byteStream);
									ByteArrayOutputStream bout = new ByteArrayOutputStream(1024);
									int read = -1;
									byte[] tembuf = new byte[1024];
									while ((read = inStream.read(tembuf, 0, 1024)) > 0) {
										bout.write(tembuf, 0, read);
									}
									bt1 = bout.toByteArray();
									baos.close();// add 0413
									byteStream.close();// add 0413
									inStream.close();// add 0413
									bout.close();// add 0413
								} else {
									bt1 = baos.toByteArray();
									baos.close();// add 0413
								}
							}
							heads = response.getHeaders("X_Sid");
							if (heads != null && heads.length > 0)
								HttpEngine.X_SID = heads[0].getValue();
							heads = response.getHeaders("X_Expired");
							if (heads != null && heads.length > 0)
								HttpEngine.X_EXPIRED = heads[0].getValue();
							HttpEngine.LAST_HTTPTIME = System.currentTimeMillis();
							// 将返回信息重置成报头,obj数组，第一个obj是包头，第二个obj是内容
							if (m_isReturnHeader) {
								retobj[0] = response.getAllHeaders();
							}
							retobj[1] = bt1;
							mg = Message.obtain();
							mg.obj = retobj;
							mg.getData().putBoolean("done", true);
							mg.getData().putString("URL", URL);

							heads = response.getHeaders("Content-Type");
							String type = null;
							if (heads != null && heads.length > 0)
								type = heads[0].getValue();
							mg.getData().putString("type", type);

							if (m_handler != null)
								m_handler.sendMessage(mg);
							if (m_client != null) {
								m_client.getConnectionManager().shutdown();// 断掉连接
							}
							is.close();// add 0413

							break;
						}
					} catch (Exception e) {
						if (m_iscanceled) {
							return;
						}
						if (connectNum >= MAXCONNEXTNUM) {
							Message mg = Message.obtain();
							mg.obj = "exception!网络有误，请确认网络设置正确或稍后重试" + URL;
							// mg.arg1=m_command;
							mg.getData().putBoolean("wrongurl", true);
							if (m_handler != null)
								m_handler.sendMessage(mg);
							e.printStackTrace();
							break;
						} else
							continue;
					}
				}
			}
		}.start();
	}

	public void cancel() {
		if (m_iscanceled)// 已经取消过了
			return;
		m_iscanceled = true;
		if (m_client != null)
			m_client.getConnectionManager().shutdown();// 断掉连接
		if (m_handler != null) {
			Message mg = Message.obtain();
			mg.obj = "已取消";
			mg.what = -21;// 错误代号
			m_handler.sendMessage(mg);
		}
	}

}
