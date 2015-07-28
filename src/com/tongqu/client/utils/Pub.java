package com.tongqu.client.utils;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.RandomAccessFile;
import java.lang.reflect.Method;
import java.nio.channels.FileChannel;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.TimeZone;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import org.apache.http.util.EncodingUtils;
import org.json.JSONObject;

import android.app.ActivityManager;
import android.app.ActivityManager.MemoryInfo;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.res.AssetManager;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.PorterDuff.Mode;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.RectF;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.os.Environment;
import android.os.Vibrator;
import android.telephony.TelephonyManager;
import android.text.format.Formatter;
import android.text.format.Time;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.TypedValue;
import android.view.Display;
import android.view.WindowManager;

import com.tongqu.client.config.GameConfig;
import com.tongqu.client.entity.AppInfo;
import com.tongqu.client.game.TQGameAndroidBridge;
import com.tongqu.client.game.TQLuaAndroidConsole;
import com.umeng.analytics.MobclickAgent;

public class Pub {

	public static final boolean mbIsDeBug = true;

	public static void LOG(String msg) {
		if (mbIsDeBug) {
			Log.i("cocos2d-x debug info", msg);
		}
	}

	/**
	 * 按行读取文件
	 *
	 * @param path
	 * @return
	 */
	public static ArrayList<String> readFileOnLine(String path) {
		File file = new File(path);
		ArrayList<String> list = new ArrayList<String>();
		try {
			BufferedReader bw = new BufferedReader(new FileReader(file));
			String line = null;
			while ((line = bw.readLine()) != null) {
				list.add(line);
			}
			bw.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return list;
	}

	/**
	 * 获取url下载地址文件名
	 *
	 * @param url
	 * @return
	 */
	public static String getFilePath(String url) {
		int nPos = url.lastIndexOf('/');
		String fileName = url.substring(nPos + 1);
		return fileName;
	}

	/**
	 * 获取后缀名
	 *
	 * @param fileName
	 * @return
	 */
	public static String getFileSuffix(String fileName) {
		String Suffix = "";
		if (fileName != null && !fileName.equals("")) {
			Suffix = fileName.substring(fileName.lastIndexOf("."));// 这个是获取后缀名
		}
		return Suffix;
	}

	/**
	 * 获取去掉后缀的字符串
	 *
	 * @param fileName
	 * @return
	 */
	public static String getFileDelSuffix(String fileName) {
		String DelSuffix = "";
		if (fileName != null && !fileName.equals("")) {
			DelSuffix = fileName.substring(0, fileName.lastIndexOf("."));// 这个是获取后缀名
		}
		return DelSuffix;
	}

	/**
	 * 获取脚本版本号
	 *
	 * @param sVersionCode
	 * @return
	 */
	public static int getScriptVerCode(String sVersionCode) {
		int verCode = 0;
		if (sVersionCode != null && !sVersionCode.equals("")) {
			int nPos = sVersionCode.indexOf('.');
			String sMainVer = sVersionCode.substring(0, nPos);
			int nMainVer = Integer.parseInt(sMainVer);
			String sSubVer = sVersionCode.substring(nPos + 1);
			int nSubVer = Integer.parseInt(sSubVer);
			verCode = (nMainVer << 24) + (nSubVer << 16);
		}
		return verCode;
	}

	/**
	 * 从Assets获取json数据文件
	 *
	 * @param fileName
	 * @return
	 */
	public static JSONObject getJSONObjectFromAssets(String fileName) {
		JSONObject obj = null;
		try {
			InputStream is = TQLuaAndroidConsole.getApplicationInstance().getAssets().open(fileName);
			byte[] buffer;
			buffer = new byte[is.available()];
			is.read(buffer);
			String json = new String(buffer, "utf-8");
			obj = new JSONObject(json);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return obj;
	}

	/**
	 * 从SD卡获取json数据文件
	 *
	 * @param fileName
	 * @return
	 */
	public static JSONObject getJSONObjectFromSD(String fileName) {
		JSONObject obj = null;
		try {
			File file = new File(fileName);
			if (!file.exists()) {
				return null;
			}
			InputStream is = new BufferedInputStream(new FileInputStream(file));
			byte[] buffer;
			buffer = new byte[is.available()];
			is.read(buffer);
			String json = new String(buffer, "utf-8");
			obj = new JSONObject(json);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return obj;
	}

	public static void setJSONObject(String dir, String fileName, String key, String value) {
		try {
			JSONObject ja = getJSONObjectFromSD(dir + fileName);
			ja.put(key, value);
			String JSONStr = ja.toString();
			writeFile(dir + fileName, JSONStr);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 *
	 * 写入json 数据
	 *
	 *
	 * @param path
	 *            要写入json 数据的文件路径
	 *
	 * @param content
	 *            写入内容
	 */

	public static void writeFile(String path, String content) {
		File file = null;
		BufferedWriter bufferw = null;
		OutputStream out = null;
		OutputStreamWriter osw = null;
		try {
			file = new File(path);
			out = new FileOutputStream(file);
			osw = new OutputStreamWriter(out, "utf-8");
			bufferw = new BufferedWriter(osw);
			bufferw.write(content);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (bufferw != null) {
				try {
					bufferw.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if (osw != null) {
				try {
					osw.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if (out != null) {
				try {
					out.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if (file != null) {
				file = null;
			}
		}
	}

	/**
	 * 判断SD卡中是否有脚本文件
	 *
	 * @param fileName
	 * @return
	 */
	public static boolean logicScriptIsExistsFromSD(String fileName) {
		File f = new File(TQGameAndroidBridge.getScriptFilePath() + fileName);
		if (!f.exists()) {
			return false;
		} else {
			// 如果SD卡上有文件
			return true;
		}
	}

	/**
	 * 判断SD卡中是否有脚本文件
	 *
	 * @param fileName
	 * @return
	 */
	public static boolean logicScriptIsExistsFromAssets(String assetDir, String fileName) {
		boolean isExists = false;
		String[] files = null;
		try {
			files = TQLuaAndroidConsole.getApplicationInstance().getResources().getAssets().list(assetDir);
			for (int i = 0; i < files.length; i++) {
				String name = files[i];
				if (fileName.equals(name)) {
					isExists = true;
					break;
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
			isExists = false;
		}

		return isExists;
	}

	/**
	 * 判断脚本文件是否已经复制到SD卡中
	 *
	 * @return true:已经在sd卡中
	 */
	public static boolean logicScriptInSD() {
		boolean isInSD = false;
		File f = new File(TQGameAndroidBridge.getScriptFilePath() + "scriptVersion.json");
		if (!f.exists()) {
			// 如果SD卡上没有脚本版本号
			isInSD = false;
		} else {
			isInSD = true;
		}
		return isInSD;
	}

	/**
	 * 从Assets卡获取脚本数据
	 *
	 * @return
	 */
	public static String getScriptDataFromAssets(String key) {
		String ScriptData = "";
		try {
			ScriptData = getJSONObjectFromAssets("scriptVersion.json").getString(key);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ScriptData;
	}

	/**
	 * 从SD获取脚本数据
	 *
	 * @return
	 */
	public static String getScriptDataFromSD(String key) {
		String ScriptData = "";
		try {
			ScriptData = getJSONObjectFromSD(TQGameAndroidBridge.getScriptFilePath() + "scriptVersion.json").getString(key);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ScriptData;
	}

	/**
	 * 读取SD卡中文本文件
	 *
	 * @param fileName
	 * @return
	 */
	public static String readSDFile(String fileName) {
		StringBuffer sb = new StringBuffer();
		File file = new File(fileName);
		FileInputStream fis = null;
		try {
			fis = new FileInputStream(file);
			int c;
			while ((c = fis.read()) != -1) {
				sb.append((char) c);
			}
			fis.close();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (fis != null) {
				try {
					fis.close();
					fis = null;
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return sb.toString();
	}

	/**
	 * 删除SD卡上的文件
	 *
	 * @param fileName
	 */
	public static boolean deleteSDFile(String fileName) {
		File file = new File(fileName);
		if (file == null || !file.exists() || file.isDirectory()) {
			return false;
		}
		return file.delete();
	}

	public static final String ENCODING = "UTF-8";

	// 从assets 文件夹中获取文件并读取数据
	public static String readAssetsFile(String fileName) {
		String result = "";
		try {
			InputStream in = TQLuaAndroidConsole.getApplicationInstance().getResources().getAssets().open(fileName);
			// 获取文件的字节数
			int lenght = in.available();
			// 创建byte数组
			byte[] buffer = new byte[lenght];
			// 将文件中的数据读到byte数组中
			in.read(buffer);
			result = EncodingUtils.getString(buffer, ENCODING);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	public static long sdFileSize = 0;

	/**
	 * 获取SD卡下文件大小
	 *
	 * @param sdDir
	 */
	public static void contrastSD(String sdDir) {
		File fileDir = new File(sdDir);
		if (fileDir.exists()) {
			if (fileDir.isDirectory()) {
				String[] fileName = fileDir.list();
				for (int i = 0; i < fileName.length; i++) {
					File temp = new File(fileDir, fileName[i]);
					if (temp.isDirectory()) {
						contrastSD(fileDir + "/" + fileName[i]);
						continue;
					}
					sdFileSize += temp.length();
				}
			}
		}
	}

	static long assetFileSize = 0;

	/**
	 * 获取Assets文件夹下文件大小
	 *
	 * @param assetDir
	 */
	public static void contrastAssets(String assetDir) {
		String[] files;
		try {
			files = TQLuaAndroidConsole.getApplicationInstance().getResources().getAssets().list(assetDir);
		} catch (IOException e) {
			e.printStackTrace();
			return;
		}

		for (int i = 0; i < files.length; i++) {
			String fileName = files[i];
			if (!fileName.contains(".")) {
				contrastAssets(assetDir + "/" + fileName);
				continue;
			}

			InputStream in;
			try {
				in = TQLuaAndroidConsole.getApplicationInstance().getResources().getAssets().open(assetDir + "/" + fileName);
				// 获取文件的字节数
				int lenght = in.available();
				assetFileSize += lenght;
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		Pub.LOG("assetFileSize ================= " + assetFileSize);
	}

	/**
	 * 复制Assets文件夹下文件到SD卡中
	 *
	 * @param assetDir
	 * @param dir
	 */
	public static void CopyAssets(String assetDir, String dir) {
		String[] files;
		try {
			files = TQLuaAndroidConsole.getApplicationInstance().getResources().getAssets().list(assetDir);
		} catch (IOException e) {
			e.printStackTrace();
			return;
		}
		File mWorkingPath = new File(dir);
		// if this directory does not exists, make one.
		if (!mWorkingPath.exists()) {
			mWorkingPath.mkdirs();
		}

		for (int i = 0; i < files.length; i++) {
			try {
				String fileName = files[i];
				// we make sure file name not contains '.' to be a folder.
				if (!fileName.contains(".")) {
					if (0 == assetDir.length()) {
						CopyAssets(fileName, dir + fileName + "/");
					} else {
						CopyAssets(assetDir + "/" + fileName, dir + fileName + "/");
					}
					continue;
				}
				File outFile = new File(mWorkingPath, fileName);
				if (outFile.exists()) {
					outFile.delete();
				}
				InputStream in = null;
				if (0 != assetDir.length())
					in = TQLuaAndroidConsole.getApplicationInstance().getAssets().open(assetDir + "/" + fileName);
				else
					in = TQLuaAndroidConsole.getApplicationInstance().getAssets().open(fileName);
				OutputStream out = new FileOutputStream(outFile);

				// Transfer bytes from in to out
				byte[] buf = new byte[1024];
				int len;
				while ((len = in.read(buf)) > 0) {
					out.write(buf, 0, len);
					try {
						Thread.sleep(5);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
				//Pub.LOG("复制文件 ================== " + fileName);
				in.close();
				out.close();
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * 拷贝Assets下的文件到SD卡中
	 *
	 * @param inFileName
	 * @param outPutDir
	 * @param OutFileName
	 */
	public static void copyBigDataToSD(String inFileName, String outPutDir, String OutFileName) {
		InputStream mInput;
		try {
			File filedir = new File(outPutDir);
			if (!filedir.exists()) {
				filedir.mkdirs();
			}
			OutputStream mOutput = new FileOutputStream(outPutDir + OutFileName);
			mInput = TQLuaAndroidConsole.getApplicationInstance().getAssets().open(inFileName);
			byte[] buffer = new byte[1024];
			int length = mInput.read(buffer);
			while (length > 0) {
				mOutput.write(buffer, 0, length);
				length = mInput.read(buffer);
			}
			mOutput.flush();
			mInput.close();
			mOutput.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 设置友盟自定义事件数据
	 *
	 * @param key
	 * @param value
	 */
	public static void setUmengUserDefinedInfo(String key, String value) {
		MobclickAgent.onEvent(TQLuaAndroidConsole.getApplicationInstance(), key, value);
	}

	/**
	 * 上传错误日志到友盟
	 *
	 * @param debugInfo
	 */
	public static void uploadingDebugInfo(String debugInfo) {
		MobclickAgent.reportError(TQLuaAndroidConsole.getApplicationInstance(), debugInfo);
	}

	/**
	 * 获取手机应用列表信息
	 *
	 * @return
	 */
	public static ArrayList<AppInfo> getPackageMsg() {
		final ArrayList<AppInfo> appList = new ArrayList<AppInfo>(); // 用来存储获取的应用信息数据
		try {
			new Thread(new Runnable() {
				@Override
				public void run() {
					List<PackageInfo> packages = TQLuaAndroidConsole.getApplicationInstance().getPackageManager().getInstalledPackages(0);
					for (int i = 0; i < packages.size(); i++) {
						PackageInfo packageInfo = packages.get(i);
						AppInfo tmpInfo = new AppInfo();
						tmpInfo.appName = packageInfo.applicationInfo.loadLabel(TQLuaAndroidConsole.getApplicationInstance().getPackageManager()).toString();
						tmpInfo.packageName = packageInfo.packageName;
						tmpInfo.versionName = packageInfo.versionName;
						tmpInfo.versionCode = packageInfo.versionCode;
						if ((packageInfo.applicationInfo.flags & ApplicationInfo.FLAG_SYSTEM) == 0) {
							tmpInfo.print();
							appList.add(tmpInfo);// 如果非系统应用，则添加至appList
						} else {
							// 系统应用
						}
					}
					LOG("packages.size() === " + packages.size());
					LOG("appList.size() === " + appList.size());
				}
			}).start();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return appList;
	}

	/**
	 * 获取应用包名
	 *
	 * @return
	 */
	public static String getAndroidPackagekName() {
		if (GameConfig.PackName == null) {
			GameConfig.PackName = TQLuaAndroidConsole.getApplicationInstance().getPackageName();
		}
		return GameConfig.PackName;
	}

	/**
	 * 得到sd卡中apk的版本号
	 *
	 * @param apkpath
	 * @return
	 */
	public static int getSdApk(String apkpath) {
		PackageInfo plocalObject = TQLuaAndroidConsole.getApplicationInstance().getPackageManager().getPackageArchiveInfo(apkpath, 1);
		if (plocalObject != null) {
			Pub.LOG(plocalObject.versionName);// 版本号
			Pub.LOG(plocalObject.versionCode + "");// 版本码
			return plocalObject.versionCode;
		} else {
			return -1;
		}
	}

	/**
	 * 复制文件(以超快的速度复制文件)
	 *
	 * @param srcFile
	 *            源文件File
	 * @param destDir
	 *            目标目录File
	 * @param newFileName
	 *            新文件名
	 * @return 实际复制的字节数，如果文件、目录不存在、文件为null、新文件已存在或者发生IO异常，返回-1
	 */
	public static long copyFile(File srcFile, File destDir, String newFileName) {
		long copySizes = 0;
		if (!srcFile.exists()) {
			Pub.LOG("源文件不存在");
			copySizes = -1;
		} else if (!destDir.exists()) {
			Pub.LOG("目标目录不存在");
			copySizes = -1;
		} else if (newFileName == null) {
			Pub.LOG("文件名为null");
			copySizes = -1;
		} else if (new File(destDir, newFileName).exists()) {
			Pub.LOG("新文件已存在");
			copySizes = -1;
		} else {
			try {
				FileChannel fcin = new FileInputStream(srcFile).getChannel();
				FileChannel fcout = new FileOutputStream(new File(destDir, newFileName)).getChannel();
				long size = fcin.size();
				fcin.transferTo(0, fcin.size(), fcout);
				fcin.close();
				fcout.close();
				copySizes = size;
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return copySizes;
	}

	/**
	 * 解压
	 *
	 * @param unZipfileName
	 * @param mDestPath
	 */
	public static void unZip(String unZipfileName, String mDestPath) {
		try {
			ZipEntry entry = null;
			FileInputStream fis = new FileInputStream(unZipfileName);
			ZipInputStream zis = new ZipInputStream(fis);
			FileOutputStream fos = null;
			while ((entry = zis.getNextEntry()) != null) {
				byte[] buffer = new byte[1024];
				String tmp = entry.getName();
				File dir = new File(mDestPath, tmp);
				if (entry.isDirectory()) {
					if (!dir.exists()) {
						dir.mkdirs();
					}
					continue;
				} else {
					// 如果指定文件的目录不存在,则创建之.
					File parent = dir.getParentFile();
					if (!parent.exists()) {
						parent.mkdirs();
					}
				}
				int readSize = 0;
				File desFile = new File(mDestPath, tmp);
				fos = new FileOutputStream(desFile);
				while ((readSize = zis.read(buffer)) > 0) {
					fos.write(buffer, 0, readSize);
					Thread.sleep(10);
				}
				if (isPics(tmp) || isMusic(tmp)) {
					desFile.renameTo(new File(mDestPath, tmp + "_data"));
				}
			}
			zis.close();
			fos.close();
			fis.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * 是否是音乐文件
	 *
	 * @param fileName
	 * @return
	 */
	public static boolean isMusic(String fileName) {
		boolean flag = false;
		if (fileName.endsWith(".mp3") || fileName.endsWith(".ogg") || fileName.endsWith(".MP3")) {
			flag = true;
		}
		return flag;
	}

	/**
	 * 从assets得到单张图片
	 *
	 * @param newFile
	 *            文件夹名字
	 * @param name
	 *            图片名字
	 * @return
	 */
	public static Bitmap getBitmap(Context c, String newFile, String name) {
		AssetManager assets = c.getResources().getAssets();
		InputStream stream = null;
		Bitmap tempBitmap = null;
		TypedValue value = new TypedValue();
		BitmapFactory.Options opts = new BitmapFactory.Options();
		opts.inTargetDensity = value.density;
		try {
			stream = assets.open(newFile + "/" + name);
			tempBitmap = BitmapFactory.decodeStream(stream, null, opts);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				if (stream != null) {
					stream.close();
					stream = null;
				}
			} catch (IOException e) {
			}
		}
		return tempBitmap;
	}

	/**
	 * 从assets得到子文件夹下所有的图片
	 *
	 * @param context
	 * @param name
	 * @return
	 */
	public static final HashMap<String, Bitmap> loadImageByListD(Context context, String name) {
		AssetManager assets = context.getResources().getAssets();
		HashMap<String, Bitmap> tempImg = new HashMap<String, Bitmap>();
		String[] nameList = null;
		InputStream in = null;
		try {
			nameList = assets.list(name);
		} catch (IOException e) {
			e.printStackTrace();
		}
		for (int i = 0; i < nameList.length; i++) {
			String tempName = nameList[i];
			try {
				if (name.equals("")) {
					in = assets.open(tempName);
				} else {
					in = assets.open(name + "/" + tempName);
				}
				Bitmap tempBitmap = BitmapFactory.decodeStream(in);
				tempImg.put(tempName, tempBitmap);
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				try {
					if (in != null) {
						in.close();
						in = null;
					}
				} catch (IOException e) {
				}
			}

		}
		return tempImg;
	}

	/**
	 * 读取sd卡上的文件下所有图片资源
	 *
	 * @param name
	 * @return 返回 HashMap<String, Bitmap> -- <文件名,图片>
	 */
	public static HashMap<String, Bitmap> readBitmapFile(String dir, String fileName) {
		if (dir == null) {
			return null;
		}
		HashMap<String, Bitmap> animationFrame = new HashMap<String, Bitmap>();
		File file = new File(dir + "/" + fileName);
		File[] files = file.listFiles();
		if (files != null && files.length > 0) {
			for (int i = 0; i < files.length; i++) {
				FileInputStream fis = null;
				try {
					fis = new FileInputStream(files[i]);
				} catch (FileNotFoundException e) {
					e.printStackTrace();
				}
				if (fis != null) {
					TypedValue value = new TypedValue();
					BitmapFactory.Options opts = new BitmapFactory.Options();
					opts.inTargetDensity = value.density;
					try {
						Bitmap tempImg = BitmapFactory.decodeStream(fis, null, opts);
						animationFrame.put(files[i].getName(), tempImg);
					} catch (OutOfMemoryError e) {
						e.printStackTrace();
					}
				}
			}
		}
		return animationFrame;
	}

	/**
	 * 获取sd卡上的单张图片资源
	 *
	 * @param url
	 * @param map
	 * @return
	 */
	public static Bitmap getSDFileBitmap(String dir, String fileName) {
		Bitmap temp = null;
		File fileDir = new File(dir);
		File file = new File(fileDir, fileName);
		if (file != null) {
			FileInputStream fis = null;
			try {
				fis = new FileInputStream(file);
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}
			if (fis != null) {
				TypedValue value = new TypedValue();
				BitmapFactory.Options opts = new BitmapFactory.Options();
				opts.inTargetDensity = value.density;
				try {
					temp = BitmapFactory.decodeStream(fis, null, opts);
				} catch (OutOfMemoryError e) {
					e.printStackTrace();
				}
			}
		}
		return temp;
	}

	/**
	 * 通过Url获得文件名
	 *
	 * @param url
	 * @return
	 */
	public static String getFileNameFromUrl(String url) {
		int index = url.lastIndexOf('/');
		return url.substring(index + 1);
	}

	public static String getFormatRemainTime(long time) {
		String strTime = "";
		int day = (int) (time / (24 * 60 * 60));
		int hour = (int) ((time % (24 * 60 * 60)) / (60 * 60));
		int min = (int) ((time % (24 * 60 * 60)) % (60 * 60)) / 60;
		if (day != 0) {
			strTime += day + "天";
			if (hour != 0) {
				strTime += hour + "小时";
			} else if (min != 0) {
				strTime += min + "分钟";
			}
		} else {
			if (hour != 0) {
				strTime += hour + "小时";
				if (min != 0) {
					strTime += min + "分钟";
				}
			} else if (min != 0) {
				strTime += min + "分钟";
			}
		}
		return strTime;
	}

	/**
	 * 是否是图片文件
	 *
	 * @param fileName
	 * @return
	 */
	public static boolean isPics(String fileName) {
		boolean flag = false;
		if (fileName.endsWith(".jpg") || fileName.endsWith(".gif") || fileName.endsWith(".bmp") || fileName.endsWith(".png")) {
			flag = true;
		}
		return flag;
	}

	/**
	 * 判断timestamp与当前时间是否在同一周
	 *
	 * @param timestamp
	 * @return
	 */
	public static boolean isInSameWeek(long timestamp) {
		if (timestamp == 0) {
			return false;
		}
		Calendar calendar = Calendar.getInstance();
		long currMls = System.currentTimeMillis();
		calendar.setTimeInMillis(currMls);
		int currDay = calendar.get(Calendar.DAY_OF_WEEK);
		currDay = currDay == 1 ? 8 : currDay;
		calendar.setTimeInMillis(timestamp);
		int lastDay = calendar.get(Calendar.DAY_OF_WEEK);
		lastDay = lastDay == 1 ? 8 : lastDay;
		if (currDay < lastDay) {//
			return false;
		}
		if (currDay == lastDay) {
			if (currMls - timestamp > 2 * 24 * 60 * 60 * 1000) {
				return false;
			}
			return true;
		}
		if (currMls - timestamp > 7 * 24 * 60 * 60 * 1000) {
			return false;
		}
		return true;
	}

	/**
	 * 当前系统是否低内存
	 *
	 * @return
	 */
	public static boolean getIsLowMemory() {
		try {
			ActivityManager am = (ActivityManager) TQLuaAndroidConsole.getApplicationInstance().getSystemService(Context.ACTIVITY_SERVICE);
			MemoryInfo mi = new MemoryInfo();
			am.getMemoryInfo(mi);
			return mi.lowMemory;
		} catch (Exception e) {
			e.printStackTrace();
			return true;
		}
	}

	/**
	 * 获取当前可用内存大小 availMem系统可用内存; threshold系统内存不足的阀值，即临界值;
	 * lowMemory如果当前可用内存<=threshold，该值为真
	 *
	 * @return
	 */
	public static String getAvailMemory() {// 获取android当前可用内存大小
		ActivityManager am = (ActivityManager) TQLuaAndroidConsole.getApplicationInstance().getSystemService(Context.ACTIVITY_SERVICE);
		MemoryInfo mi = new MemoryInfo();
		am.getMemoryInfo(mi);
		// mi.availMem; 当前系统的可用内存
		String availMem = Formatter.formatFileSize(TQLuaAndroidConsole.getApplicationInstance().getBaseContext(), mi.availMem);// 将获取的内存大小规格化
		String threshold = Formatter.formatFileSize(TQLuaAndroidConsole.getApplicationInstance().getBaseContext(), mi.threshold);// 将获取的系统内存不足的阀值，即临界值规格化
		// Integer.parseInt((availMem.replace("MB", "")));
		return mi.availMem + "  " + mi.threshold + "  " + mi.lowMemory;
	}

	/**
	 * 得到设备序列号
	 *
	 * @return
	 */
	public static String getSerialNumber() {
		String serial = null;
		try {
			Class<?> c = Class.forName("android.os.SystemProperties");
			Method get = c.getMethod("get", String.class);
			serial = (String) get.invoke(c, "ro.serialno");
		} catch (Exception ignored) {
		}
		return serial;
	}

	/**
	 * 获取CPU序列号
	 *
	 * @return CPU序列号(16位) 读取失败为"0000000000000000"
	 */

	public static String getCPUSerial() {
		String str = "", strCPU = "", cpuAddress = "0000000000000000";
		try {
			// 读取CPU信息
			Process pp = Runtime.getRuntime().exec("cat /proc/cpuinfo");
			InputStreamReader ir = new InputStreamReader(pp.getInputStream());
			LineNumberReader input = new LineNumberReader(ir);
			// 查找CPU序列号
			for (int i = 1; i < 100; i++) {
				str = input.readLine();
				if (str != null) {
					// 查找到序列号所在行
					if (str.indexOf("Serial") > -1) {
						// 提取序列号
						strCPU = str.substring(str.indexOf(":") + 1, str.length());
						// 去空格
						cpuAddress = strCPU.trim();
						break;
					}
				} else {
					// 文件结尾
					break;
				}
			}
		} catch (IOException ex) {
			// 赋予默认值
			ex.printStackTrace();
		}
		return cpuAddress;
	}

	/**
	 * 得到当前界面是否是横屏
	 *
	 * @return true:横屏 false:竖屏
	 */
	public static boolean isLandscape() {
		boolean islandscape = false;
		Configuration cf = TQLuaAndroidConsole.getApplicationInstance().getResources().getConfiguration();
		if (cf.orientation == Configuration.ORIENTATION_LANDSCAPE) {
			islandscape = true;
			Pub.LOG("横屏------------------------------");
		} else if (cf.orientation == Configuration.ORIENTATION_PORTRAIT) {
			islandscape = false;
			Pub.LOG("竖屏------------------------------");
		}
		return islandscape;
	}

	/**
	 * 判断设备是否是手机
	 *
	 * @param mContext
	 * @return true是手机 false是平板
	 */
	public static boolean logicDevice(Context mContext) {
		boolean isPhone = true;
		if (!isCanCallTelephony(mContext) && isPad(mContext)) {
			// 大于6寸且不能打电话
			isPhone = false;
		}
		if (!isCanCallTelephony(mContext) && !isPhone(mContext)) {
			isPhone = false;
		}
		return isPhone;
	}

	/**
	 * 得到是否是手机/平板设备
	 *
	 * @param mContext
	 * @return true是手机 false是平板
	 */

	public static boolean isPhone(Context mContext) {
		if (android.os.Build.VERSION.SDK_INT >= 11) { // honeycomb
			// test screen size, use reflection because isLayoutSizeAtLeast is
			// only available since 11
			try {
				Configuration con = mContext.getResources().getConfiguration();
				Method mIsLayoutSizeAtLeast = con.getClass().getMethod("isLayoutSizeAtLeast", int.class);
				Boolean r = (Boolean) mIsLayoutSizeAtLeast.invoke(con, 0x00000004); // Configuration.SCREENLAYOUT_SIZE_XLARGE
				if (r) {
					Pub.LOG("此设备是平板设备");
				} else {
					Pub.LOG("此设备是手机设备");
				}
				return !r;
			} catch (Exception x) {
				x.printStackTrace();
				return true;
			}
		}
		return true;
	}

	/**
	 * 是否可以打电话
	 *
	 * @param mContext
	 * @return
	 */
	public static boolean isCanCallTelephony(Context mContext) {
		TelephonyManager telephony = (TelephonyManager) mContext.getSystemService(Context.TELEPHONY_SERVICE);
		int type = telephony.getPhoneType();
		boolean isCanCall = false;
		if (type == TelephonyManager.PHONE_TYPE_NONE) {
			isCanCall = false;
		} else {
			isCanCall = true;
		}
		return isCanCall;
	}

	/**
	 * 判断是否为平板 大于6尺寸则为平板
	 *
	 * @return
	 */
	public static boolean isPad(Context mContext) {
		WindowManager wm = (WindowManager) mContext.getSystemService(Context.WINDOW_SERVICE);
		Display display = wm.getDefaultDisplay();
		// 屏幕宽度
		float screenWidth = display.getWidth();
		// 屏幕高度
		float screenHeight = display.getHeight();
		DisplayMetrics dm = new DisplayMetrics();
		display.getMetrics(dm);
		double x = Math.pow(dm.widthPixels / dm.xdpi, 2);
		double y = Math.pow(dm.heightPixels / dm.ydpi, 2);
		// 屏幕尺寸
		double screenInches = 0;
		double screen1 = Math.sqrt(x + y);
		double screen2 = Math.sqrt(Math.pow(dm.widthPixels, 2) + Math.pow(dm.heightPixels, 2)) / (160 * dm.density);

		screenInches = screen1 > screen2 ? screen2 : screen1;

		// 大于6尺寸则为Pad
		if (screenInches >= 6.0) {
			return true;
		}
		return false;
	}

	/**
	 * 得到写文件的路径
	 *
	 * @param dir
	 *            有子文件夹格式：xxxx/，无：""
	 * @return
	 */
	public static String getTrendsSaveFilePath(String dir) {
		String trendsSavePath;
		if (!Environment.getExternalStorageDirectory().canWrite()) {
			trendsSavePath = TQLuaAndroidConsole.getApplicationInstance().getFilesDir().getAbsolutePath() + "/" + dir + "/";
			File filedir = new File(trendsSavePath);
			if (!filedir.exists()) {
				filedir.mkdirs();
				Pub.LOG("trendsSavePath:" + trendsSavePath);
			}
			return trendsSavePath;
		}
		trendsSavePath = Environment.getExternalStorageDirectory() + "/" + dir + "/";
		File filedir = new File(trendsSavePath);
		if (!filedir.exists()) {
			filedir.mkdirs();
			Pub.LOG("trendsSavePath:" + trendsSavePath);
		}
		return trendsSavePath;
	}

	/**
	 * 在应用内创建文件夹
	 *
	 * @param dir
	 *            有子文件夹格式：xxxx/，无：""
	 * @return
	 */
	public static String getTrendsSaveFilePathOwned(String dir) {
		String trendsSavePath;
		trendsSavePath = TQLuaAndroidConsole.getApplicationInstance().getFilesDir().getAbsolutePath() + "/" + dir + "/";
		File filedir = new File(trendsSavePath);
		if (!filedir.exists()) {
			filedir.mkdirs();
			Pub.LOG("trendsSavePath:" + trendsSavePath);
		}
		return trendsSavePath;
	}

	private static String SAVE_DATA_PATH;

	/**
	 * 得到写文件的路径
	 *
	 * @return
	 */
	public static String getSaveFilePath() {
		if (SAVE_DATA_PATH != null) {
			return SAVE_DATA_PATH;
		}
		if (!Environment.getExternalStorageDirectory().canWrite()) {
			SAVE_DATA_PATH = TQLuaAndroidConsole.getApplicationInstance().getFilesDir().getAbsolutePath() + "/";
			Pub.LOG("SAVE_USER_PATH:" + SAVE_DATA_PATH);
			return SAVE_DATA_PATH;
		}
		SAVE_DATA_PATH = Environment.getExternalStorageDirectory() + "/TqPic/";
		Pub.LOG("SAVE_USER_PATH:" + SAVE_DATA_PATH);
		File filedir = new File(SAVE_DATA_PATH);
		if (!filedir.exists()) {
			filedir.mkdirs();
		}
		return SAVE_DATA_PATH;
	}

	/**
	 * sim卡是否可用
	 *
	 * @return
	 */
	public static boolean isCanUseSim() {
		try {
			TelephonyManager mgr = (TelephonyManager) TQLuaAndroidConsole.getApplicationInstance().getSystemService(Context.TELEPHONY_SERVICE);
			return TelephonyManager.SIM_STATE_READY == mgr.getSimState();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	/**
	 * 获取运营商类型
	 *
	 * @return
	 */
	public static String getImsi() {
		TelephonyManager tm = (TelephonyManager) TQLuaAndroidConsole.getApplicationInstance().getSystemService(Context.TELEPHONY_SERVICE);
		String IMSI = tm.getSubscriberId();
		if (IMSI == null) {
			return "";
		}
		return IMSI;
	}

	public static final int CHINA_MOBILE = 1;// 移动
	public static final int CHINA_UNICOM = 2;// 联通
	public static final int CHINA_TELECOM = 3;// 电信

	public static int selfOperater = -1;

	/**
	 * 获取运营商类型
	 *
	 * @return
	 */
	public static int getOperater() {
		if (selfOperater >= 0) {
			return selfOperater;
		}
		int type = 0;// 0未知1移动2联通3电信
		TelephonyManager tm = (TelephonyManager) TQLuaAndroidConsole.getApplicationInstance().getSystemService(Context.TELEPHONY_SERVICE);
		String IMSI = tm.getSubscriberId();
		if (IMSI == null) {
			return type;
		}
		// IMSI号前面3位460是国家，紧接着后面2位00 02是中国移动，01是中国联通，03是中国电信。
		if (IMSI.startsWith("46000") || IMSI.startsWith("46002") || IMSI.startsWith("46007")) {
			type = CHINA_MOBILE;
		} else if (IMSI.startsWith("46001")) {
			type = CHINA_UNICOM;
		} else if (IMSI.startsWith("46003")) {
			type = CHINA_TELECOM;
		}
		selfOperater = type;
		return selfOperater;
	}

	/**
	 * 是否24小时之内
	 *
	 * @param lastTime
	 *            记录中的时间
	 * @return
	 */
	public static boolean IsOutOneDay(long lastTime) {
		long lastDay = (int) (lastTime / (24 * 60 * 60 * 1000));
		long toDay = (System.currentTimeMillis() / (24 * 60 * 60 * 1000));
		if (lastDay == toDay) {
			return false;// 同一天
		} else {
			return true;// 不是同一天
		}
	}

	/**
	 * 是否24*7小时之内
	 *
	 * @param lastTime
	 *            记录中的时间
	 * @return
	 */
	public static boolean IsOutSevenDay(long lastTime) {
		long lastDay = (int) (lastTime / (24 * 60 * 60 * 1000));
		long toDay = (System.currentTimeMillis() / (24 * 60 * 60 * 1000));
		if (toDay - lastDay > 7) {
			return true;// 超过7天
		} else {
			return false;// 未超过7天
		}
	}

	public static long getDays(long time) {
		return time / (24 * 60 * 60 * 1000);
	}

	/**
	 * 数组倒序
	 *
	 * @param array
	 * @return
	 */
	public static float[] reverseOrder(float[] array) {
		for (int i = 0; i < array.length / 2; i++) {
			swap(array, i, array.length - 1 - i);
		}
		return array;
	}

	/**
	 * 是否为中文、数字、字母
	 *
	 * @param s
	 * @return
	 */
	public static boolean isChineseOrLetterOrNum(String s) {
		if (s == null) {
			return false;
		}
		char[] ac = s.toCharArray();
		for (int i = 0; i < ac.length; i++) {
			if (CharType.DELIMITER == getCharType(ac[i])) {
				return false;
			}
			if (CharType.OTHER == getCharType(ac[i])) {
				return false;
			}
		}
		return true;
	}

	/**
	 * 是否包含中文
	 *
	 * @param s
	 * @return
	 */
	public static boolean containChinese(String s) {
		if (s == null) {
			return false;
		}
		char[] ac = s.toCharArray();
		for (int i = 0; i < ac.length; i++) {
			if (CharType.CHINESE == getCharType(ac[i])) {
				return true;
			}
		}
		return false;
	}

	enum CharType {
		DELIMITER, // 非字母截止字符，例如，．）（　等等　（ 包含U0000-U0080）
		NUM, // 2字节数字１２３４
		LETTER, // gb2312中的，例如:ＡＢＣ，2字节字符同时包含 1字节能表示的 basic latin and latin-1
		OTHER, // 其他字符
		CHINESE;// 中文字
	}

	/**
	 * 判断输入char类型变量的字符类型
	 *
	 * @param c
	 *            char类型变量
	 * @return CharType 字符类型
	 */
	public static CharType getCharType(char c) {
		CharType ct = null;

		// 中文，编码区间0x4e00-0x9fbb
		if ((c >= 0x4e00) && (c <= 0x9fbb)) {
			ct = CharType.CHINESE;
		} else if ((c >= 0xff00) && (c <= 0xffef)) {
			// Halfwidth and Fullwidth Forms， 编码区间0xff00-0xffef
			// 2字节英文字
			if (((c >= 0xff21) && (c <= 0xff3a)) || ((c >= 0xff41) && (c <= 0xff5a))) {
				ct = CharType.LETTER;
			} else if ((c >= 0xff10) && (c <= 0xff19)) {
				// 2字节数字
				ct = CharType.NUM;
			} else {
				// 其他字符，可以认为是标点符号
				ct = CharType.DELIMITER;
			}
		} else if ((c >= 0x0021) && (c <= 0x007e)) {
			// basic latin，编码区间 0000-007f
			// 1字节数字
			if ((c >= 0x0030) && (c <= 0x0039)) {
				ct = CharType.NUM;
			} // 1字节字符
			else if (((c >= 0x0041) && (c <= 0x005a)) || ((c >= 0x0061) && (c <= 0x007a))) {
				ct = CharType.LETTER;
			}
			// 其他字符，可以认为是标点符号
			else
				ct = CharType.DELIMITER;
		}

		// latin-1，编码区间0080-00ff
		else if ((c >= 0x00a1) && (c <= 0x00ff)) {
			if ((c >= 0x00c0) && (c <= 0x00ff)) {
				ct = CharType.LETTER;
			} else
				ct = CharType.DELIMITER;
		} else
			ct = CharType.OTHER;

		return ct;
	}

	private static void swap(float[] array, int i, int j) {
		float tmp = array[i];
		array[i] = array[j];
		array[j] = tmp;
	}

	/**
	 * * 转为字符串 * * @param obj * @return 为null时返回空字符串
	 */
	public static String objectToString(Object obj) {
		String str = "";
		try {
			str = (String) obj;
			if (str == null) {
				str = "";
			}
		} catch (ClassCastException ce) {
			try {
				str = String.valueOf(obj);
			} catch (Exception e) {
				str = "";
			}
		}
		return str.trim();
	}

	/**
	 * 数组由小到大
	 *
	 * @param srcArray
	 * @return
	 */
	public static int[] order(int[] srcArray) {
		int[] dist = new int[srcArray.length];
		System.arraycopy(srcArray, 0, dist, 0, srcArray.length);
		for (int i = 0; i < dist.length; i++) {
			int lowerIndex = i;
			// 找出最小的一个索引
			for (int j = i + 1; j < dist.length; j++) {
				if (dist[j] < dist[lowerIndex]) {
					lowerIndex = j;
				}
			}
			// 交换
			int temp = dist[i];
			dist[i] = dist[lowerIndex];
			dist[lowerIndex] = temp;
		}
		return dist;
	}

	public static String[] splitStr(String str, String c) {
		ArrayList<String> al = new ArrayList<String>();
		while (true) {
			int nPos = str.indexOf(c);
			if (nPos == -1) {
				nPos = str.length();
			}
			String s = str.substring(0, nPos);
			al.add(s);
			if (nPos == str.length()) {
				break;
			}
			str = str.substring(nPos + c.length());
			if (str.equals("")) {
				al.add("");
				break;
			}
		}
		String[] as = new String[al.size()];
		al.toArray(as);
		return as;
	}

	public static boolean inArray(int[] an, int n) {
		if (an == null) {
			return false;
		}
		for (int i = 0; i < an.length; i++) {
			if (an[i] == n) {
				return true;
			}
		}
		return false;
	}

	/**
	 * 往object数组里添加一个元素
	 */
	public static Object[] addObjectToArray(Object[] srcArray, Object val) {
		Object[] dist = new Object[srcArray.length + 1];
		System.arraycopy(srcArray, 0, dist, 0, srcArray.length);
		dist[srcArray.length] = val;
		return dist;
	}

	/**
	 * 往int数组里添加一个元素
	 */
	public static int[] addIntToArray(int[] srcArray, int val) {
		int[] dist = new int[srcArray.length + 1];
		System.arraycopy(srcArray, 0, dist, 0, srcArray.length);
		dist[srcArray.length] = val;
		return dist;
	}

	/**
	 * 往int里面插入一个元素
	 */
	public static int[] insertIntToArray(int[] srcArray, int index, int val) {
		int[] dist = new int[srcArray.length + 1];
		System.arraycopy(srcArray, 0, dist, 0, index);
		dist[index] = val;
		System.arraycopy(srcArray, index, dist, index + 1, srcArray.length - index);
		return dist;
	}

	/**
	 * 从int里面删除一个元素
	 */
	public static int[] delIntFromArray(int[] srcArray, int index) {
		if (srcArray.length < 0) {
			return null;
		}
		int[] dist = new int[srcArray.length - 1];
		System.arraycopy(srcArray, 0, dist, 0, index);
		System.arraycopy(srcArray, index + 1, dist, index, srcArray.length - index - 1);
		return dist;
	}

	public static int[] delIntFromArray1(int[] srcArray, int val) {
		if (srcArray.length < 0) {
			return null;
		}
		for (int i = 0; i < srcArray.length; i++) {
			if (val == srcArray[i]) {
				return delIntFromArray(srcArray, i);
			}
		}
		return null;
	}

	public static String[] addStringToArray(String[] srcArray, String s) {
		String[] dist = new String[srcArray.length + 1];
		System.arraycopy(srcArray, 0, dist, 0, srcArray.length);
		dist[srcArray.length] = s;
		return dist;
	}

	public static boolean inRect(int PointX, int PointY, int RectX, int RectY, int RectW, int RectH) {
		return (PointX > RectX && PointX < RectX + RectW && PointY > RectY && PointY < RectY + RectH);
	}

	/**
	 * CPU利用率
	 *
	 * @return
	 */
	public static float readUsage() {
		try {
			RandomAccessFile reader = new RandomAccessFile("/proc/stat", "r");

			String load = reader.readLine();

			String[] toks = load.split(" ");

			long idle1 = Long.parseLong(toks[5]);

			long cpu1 = Long.parseLong(toks[2]) + Long.parseLong(toks[3]) + Long.parseLong(toks[4]) + Long.parseLong(toks[6]) + Long.parseLong(toks[7]) + Long.parseLong(toks[8]);

			try {
				Thread.sleep(360);

			} catch (Exception e) {
			}

			reader.seek(0);

			load = reader.readLine();

			reader.close();

			toks = load.split(" ");

			long idle2 = Long.parseLong(toks[5]);

			long cpu2 = Long.parseLong(toks[2]) + Long.parseLong(toks[3]) + Long.parseLong(toks[4]) + Long.parseLong(toks[6]) + Long.parseLong(toks[7]) + Long.parseLong(toks[8]);

			return (int) (100 * (cpu2 - cpu1) / ((cpu2 + idle2) - (cpu1 + idle1)));

		} catch (IOException ex) {
			ex.printStackTrace();

		}

		return 0;
	}

	public static String getGameTimeAsString(int time, boolean bHundreds) {
		StringBuffer result_time = new StringBuffer();
		String symbol = ":";
		if (time <= 0) {
			return "00:00";
		}
		String minutes = getPrettyNumber(time / 60);
		String seconds = getPrettyNumber(time % 60);
		String hundreds = "";
		if (bHundreds) {
			hundreds = getPrettyNumber((time / 10) % 100);
		}

		result_time.append(minutes);
		result_time.append(symbol);
		result_time.append(seconds);
		if (bHundreds) {
			result_time.append(symbol);
			result_time.append(hundreds);
		}

		return result_time.toString();
	}

	public static int[] Millis2Time(long mills)// unix时间戳，毫秒值
	{
		int an[] = new int[2];
		if (mills < 1)
			return an;
		SimpleDateFormat f1 = new SimpleDateFormat("HH");
		f1.setTimeZone(TimeZone.getTimeZone("GMT+8"));
		SimpleDateFormat f2 = new SimpleDateFormat("mm");
		f2.setTimeZone(TimeZone.getTimeZone("GMT+8"));
		// SimpleDateFormat formatter = new
		// SimpleDateFormat("yyyy-MM-dd  HH:mm");
		Date curDate = new Date(mills);// 获取当前时间
		String time = "";
		time = f1.format(curDate);
		an[0] = Integer.parseInt(time);
		time = f2.format(curDate);
		an[1] = Integer.parseInt(time);
		return an;
	}

	/**
	 * 格式化数字转换为时间yyyy-MM-dd HH:mm
	 *
	 * @param mills
	 * @return
	 */
	public static String formattingTime(long mills) {
		if (mills < 1) {
			return "";
		}
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd  HH:mm");
		Date curDate = new Date(mills);// 获取当前时间
		String time = formatter.format(curDate);
		return time;
	}

	/**
	 * 将短时间格式字符串转换为时间 yyyy-MM-dd HH:mm:ss
	 *
	 * @param strDate
	 * @return
	 */
	public static Date parseDate(String strDate) {
		if (strDate == null || "".equals(strDate)) {
			return new Date();
		}
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		ParsePosition pos = new ParsePosition(0);
		Date strtodate = formatter.parse(strDate, pos);
		return strtodate;
	}

	// G 年代标志符
	// y 年
	// M 月
	// d 日
	// h 时 在上午或下午 (1~12)
	// H 时 在一天中 (0~23)
	// m 分
	// s 秒
	// S 毫秒
	// E 星期
	// D 一年中的第几天
	// F 一月中第几个星期几
	// w 一年中第几个星期
	// W 一月中第几个星期
	// a 上午 / 下午 标记符
	// k 时 在一天中 (1~24//
	// K 时 在上午或下午 (0~11)
	// z 时区

	/**
	 * 按照formater的格式，格式化date
	 *
	 * @param date
	 * @param formater
	 * @return
	 */
	public static String formatDate(Date date, String formater) {
		SimpleDateFormat formatter = new SimpleDateFormat(formater);
		return formatter.format(date);
	}

	private static String getPrettyNumber(int n) {
		if (n < 0) {
			n = -n;
		}
		if (n < 10) {
			return "0" + n;
		}
		return String.valueOf(n);
	}

	public static void writeFile(String filePath, byte[] abData) {
		InputStream is = new ByteArrayInputStream(abData);
		writeFile(filePath, is);
	}

	public static void writeFile(String filePath, InputStream is) {
		File file = new File(filePath);
		try {
			int nPos = filePath.lastIndexOf('/');
			String sDir = filePath.substring(0, nPos);
			File dir = new File(sDir);
			if (!dir.exists()) {
				dir.mkdirs();
			}
			OutputStream outstream = new FileOutputStream(file);
			byte[] buffer = new byte[1024];
			int len = 0;
			while ((len = is.read(buffer)) != -1) {
				outstream.write(buffer, 0, len);
			}
			outstream.close();
		} catch (java.io.IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 写文本文件
	 *
	 * @param filePath
	 * @param content
	 */
	public static void writeTxt(String filePath, String content) {

		// 保存文件
		File file = new File(filePath);
		try {
			OutputStream outstream = new FileOutputStream(file);
			OutputStreamWriter out = new OutputStreamWriter(outstream);
			out.write(content);
			out.close();
		} catch (java.io.IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 读文本文件
	 *
	 * @param path
	 * @return
	 */
	public static String readTxt(String path) {
		String content = "";
		// 打开文件
		File file = new File(path);
		// 如果path是传递过来的参数，可以做一个非目录的判断
		if (file.isDirectory()) {
			// Toast.makeText(EasyNote.this, "没有指定文本文件！", 1000).show();
		} else {
			try {
				InputStream instream = new FileInputStream(file);
				if (instream != null) {
					InputStreamReader inputreader = new InputStreamReader(instream);
					BufferedReader buffreader = new BufferedReader(inputreader);
					String line;
					// 分行读取
					while ((line = buffreader.readLine()) != null) {
						content += line + "\n";
					}
					instream.close();
				}
			} catch (java.io.FileNotFoundException e) {
				// Toast.makeText(EasyNote.this, "文件不存在",
				// Toast.LENGTH_SHORT).show();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		content = content.trim();
		return content;
	}

	/**
	 * CPU信息(主频)
	 *
	 * @return
	 */
	public static float getCpuInfo() {
		String str1 = "/proc/cpuinfo";
		String str2 = "";
		String cpuInfo = "";
		String[] arrayOfString;
		try {
			FileReader fr = new FileReader(str1);
			BufferedReader localBufferedReader = new BufferedReader(fr, 8192);
			str2 = localBufferedReader.readLine();
			// arrayOfString = str2.split("\\s+");
			// for (int i = 2; i < arrayOfString.length; i++) {
			// cpuInfo[0] = cpuInfo[0] + arrayOfString[i] + " ";
			// }
			str2 = localBufferedReader.readLine();
			arrayOfString = str2.split("\\s+");
			cpuInfo += arrayOfString[2];
			localBufferedReader.close();
		} catch (IOException e) {
		}
		float f = Float.parseFloat(cpuInfo);
		return f;
	}

	public static boolean isWeakCPU() {
		boolean WEAK_CPU = false;
		try {
			long nCpuFreq = Long.parseLong(getMaxCpuFreq());
			if (nCpuFreq >= 800000) {
				WEAK_CPU = false;
			} else {
				WEAK_CPU = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return WEAK_CPU;
	}

	// 获取CPU最大频率（单位KHZ）

	public static String MaxCpuFreq = null;

	// 获取CPU最大频率（单位KHZ）
	public static String getMaxCpuFreq() {
		if (MaxCpuFreq != null) {
			return MaxCpuFreq;
		}
		String result = "";
		ProcessBuilder cmd;
		try {
			String[] args = { "/system/bin/cat", "/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq" };
			cmd = new ProcessBuilder(args);
			Process process = cmd.start();
			InputStream in = process.getInputStream();
			byte[] re = new byte[24];
			while (in.read(re) != -1) {
				result = result + new String(re);
			}
			in.close();
		} catch (IOException ex) {
			ex.printStackTrace();
			result = "N/A";
		}
		MaxCpuFreq = result.trim();
		return MaxCpuFreq;
	}

	// 获取CPU最小频率（单位KHZ）
	public static String getMinCpuFreq() {
		String result = "";
		ProcessBuilder cmd;
		try {
			String[] args = { "/system/bin/cat", "/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq" };
			cmd = new ProcessBuilder(args);
			Process process = cmd.start();
			InputStream in = process.getInputStream();
			byte[] re = new byte[24];
			while (in.read(re) != -1) {
				result = result + new String(re);
			}
			in.close();
		} catch (IOException ex) {
			ex.printStackTrace();
			result = "N/A";
		}
		return result.trim();
	}

	// 实时获取CPU当前频率（单位KHZ）
	public static String getCurCpuFreq() {
		String result = "N/A";
		try {
			FileReader fr = new FileReader("/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq");
			BufferedReader br = new BufferedReader(fr);
			String text = br.readLine();
			result = text.trim();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 根据手机的分辨率从 dp 的单位 转成为 px(像素)
	 */
	public static int dip2px(Context context, float dpValue) {
		final float scale = context.getResources().getDisplayMetrics().density;
		return (int) (dpValue * scale + 0.5f);
	}

	/**
	 * 根据手机的分辨率从 px(像素) 的单位 转成为 dp
	 */
	public static int px2dip(Context context, float pxValue) {
		final float scale = context.getResources().getDisplayMetrics().density;
		return (int) (pxValue / scale + 0.5f);
	}

	// public static int dip2px(Context context, float dipValue) {
	// final float scale =
	// context.getResources().getDisplayMetrics().densityDpi;
	// return (int) (dipValue * (scale / 160) + 0.5f);
	// }
	//
	// public static int px2dp(Context context, float pxValue) {
	// final float scale =
	// context.getResources().getDisplayMetrics().densityDpi;
	// return (int) ((pxValue * 160) / scale + 0.5f);
	// }

	public static void getHourMinute(int[] data) {
		Time t = new Time(); // or Time t=new Time("GMT+8"); 加上Time Zone资料。

		t.setToNow(); // 取得系统时间

		data[0] = t.hour; // 0-23
		data[1] = t.minute;
	}

	public static Bitmap loadBitmap(Context context, int drawableId) {
		Bitmap bitmap = null;
		BitmapFactory.Options opt = new BitmapFactory.Options();
		TypedValue value = new TypedValue();
		opt.inPreferredConfig = Bitmap.Config.RGB_565;
		opt.inJustDecodeBounds = false;
		opt.inDither = false;
		opt.inPurgeable = true;
		opt.inInputShareable = true;
		opt.inTargetDensity = value.density;
		InputStream is = context.getResources().openRawResource(drawableId);
		try {
			bitmap = BitmapFactory.decodeStream(is, null, opt);
		} finally {
			try {
				is.close();
				is = null;
			} catch (IOException e) {
			}
		}
		return bitmap;
	}

	public static Bitmap loadBitmap(Context context, String resName) {
		try {
			resName = resName.toLowerCase();
			String fn = resName;
			int i = fn.lastIndexOf('/');
			if (i >= 0) {
				fn = fn.substring(i + 1);
			}
			int j = fn.indexOf(".png");
			if (j > 0) {
				fn = fn.substring(0, j);
			}
			return decodeResource(context.getResources(), context.getResources().getIdentifier(fn, "drawable", context.getPackageName()));
		} catch (OutOfMemoryError e) {
			e.printStackTrace();
			return null;
		}

	}

	private static Bitmap decodeResource(Resources resources, int id) {
		TypedValue value = new TypedValue();
		resources.openRawResource(id, value);
		BitmapFactory.Options opts = new BitmapFactory.Options();
		opts.inTargetDensity = value.density;
		return BitmapFactory.decodeResource(resources, id, opts);
	}

	public static Bitmap scaleImage(Bitmap bitmap, int dst_w, int dst_h) {
		int src_w = bitmap.getWidth();
		int src_h = bitmap.getHeight();
		if (src_w == dst_w && src_h == dst_h) {
			return bitmap;
		}
		float scale_w = ((float) dst_w) / src_w;
		float scale_h = ((float) dst_h) / src_h;
		Matrix matrix = new Matrix();
		matrix.postScale(scale_w, scale_h);
		Bitmap dstbmp = Bitmap.createBitmap(bitmap, 0, 0, src_w, src_h, matrix, true);
		bitmap.recycle();
		return dstbmp;
	}

	public static Bitmap scaleImage(Bitmap bitmap, float scale, boolean recycle) {
		if (scale == 1.0f || getIsLowMemory()) {
			System.gc();
			return bitmap;
		}
		Bitmap dstbmp = bitmap;
		try {
			int src_w = bitmap.getWidth();
			int src_h = bitmap.getHeight();

			Matrix matrix = new Matrix();
			matrix.postScale(scale, scale);
			dstbmp = Bitmap.createBitmap(bitmap, 0, 0, src_w, src_h, matrix, true);
			if (recycle) {
				bitmap.recycle();
			}
		} catch (OutOfMemoryError e) {
			e.printStackTrace();
		}
		return dstbmp;
	}

	/**
	 * 圆角图片
	 */
	public static Bitmap getRoundedCornerBitmap(Bitmap bitmap, float roundPx) {
		if (getIsLowMemory()) {
			System.gc();
			return bitmap;
		}
		Bitmap output = bitmap;
		try {
			output = Bitmap.createBitmap(bitmap.getWidth(), bitmap.getHeight(), Config.ARGB_8888);
			Canvas canvas = new Canvas(output);
			final int color = 0xff424242;
			final Paint paint = new Paint();
			final Rect rect = new Rect(0, 0, bitmap.getWidth(), bitmap.getHeight());
			final RectF rectF = new RectF(rect);
			paint.setAntiAlias(true);
			canvas.drawARGB(0, 0, 0, 0);
			paint.setColor(color);
			canvas.drawRoundRect(rectF, roundPx, roundPx, paint);
			paint.setXfermode(new PorterDuffXfermode(Mode.SRC_IN));
			canvas.drawBitmap(bitmap, rect, rect, paint);
		} catch (OutOfMemoryError e) {
			e.printStackTrace();
		}
		// bitmap.recycle();
		return output;
	}

	/**
	 * 得到手机型号
	 */
	public static String getModel() {
		return Build.MODEL;
	}

	/**
	 * 得到系统版本号
	 */
	public static String getSDK_VERSION() {
		return android.os.Build.VERSION.RELEASE;
	}

	public static int mnNetType = 0;// 联网类型

	public static final int NET_WIFI = 1;
	public static final int NET_2G = 2;
	public static final int NET_3G = 3;
	public static final int NET_4G = 4;

	public static int getConnectionType() {
		if (mnNetType > 0) {
			return mnNetType;
		}
		ConnectivityManager manager = (ConnectivityManager) TQLuaAndroidConsole.getApplicationInstance().getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo info = manager.getActiveNetworkInfo();
		if (info == null) {
			mnNetType = 0;
			return mnNetType;
		}
		int netType = info.getType();
		int netSubtype = info.getSubtype();
		if (netType == ConnectivityManager.TYPE_WIFI) {
			mnNetType = NET_WIFI;
		} else {
			switch (netSubtype) {
			case TelephonyManager.NETWORK_TYPE_GPRS:
			case TelephonyManager.NETWORK_TYPE_EDGE:
			case TelephonyManager.NETWORK_TYPE_CDMA:
			case TelephonyManager.NETWORK_TYPE_1xRTT:
			case TelephonyManager.NETWORK_TYPE_IDEN:
				mnNetType = NET_2G;
				break;
			case TelephonyManager.NETWORK_TYPE_UMTS:
			case TelephonyManager.NETWORK_TYPE_EVDO_0:
			case TelephonyManager.NETWORK_TYPE_EVDO_A:
			case TelephonyManager.NETWORK_TYPE_HSDPA:
			case TelephonyManager.NETWORK_TYPE_HSUPA:
			case TelephonyManager.NETWORK_TYPE_HSPA:
			case TelephonyManager.NETWORK_TYPE_EVDO_B:
			case TelephonyManager.NETWORK_TYPE_EHRPD:
			case TelephonyManager.NETWORK_TYPE_HSPAP:
				mnNetType = NET_3G;
				break;
			case TelephonyManager.NETWORK_TYPE_LTE:
				mnNetType = NET_4G;
				break;
			default:
				break;
			}
		}
		return mnNetType;
	}

	/**
	 * 得到联网方式
	 */
	public static String getNetType() {
		try {
			ConnectivityManager cm = (ConnectivityManager) TQLuaAndroidConsole.getApplicationInstance().getSystemService(Context.CONNECTIVITY_SERVICE);
			NetworkInfo info = cm.getActiveNetworkInfo();
			if (info == null) {
				return "";
			}
			String typeName = info.getTypeName(); // WIFI/MOBILE
			int type = info.getType();
			if (type == ConnectivityManager.TYPE_WIFI) {

			} else {
				typeName = info.getExtraInfo(); // 3gnet/3gwap/uninet/uniwap/cmnet/cmwap/ctnet/ctwap
			}
			if (typeName == null) {
				return "";
			}
			return typeName;
		} catch (Exception e) {
			return "";
		}
	}

	/**
	 * 得到运营商的名称
	 */
	public static String getNetName() {
		try {
			ConnectivityManager cm = (ConnectivityManager) TQLuaAndroidConsole.getApplicationInstance().getSystemService(Context.CONNECTIVITY_SERVICE);
			NetworkInfo info = cm.getActiveNetworkInfo();
			String netName = null;
			int type = info.getType();
			if (type == ConnectivityManager.TYPE_WIFI) {
				netName = info.getTypeName(); // WIFI/MOBILE
			} else {
				TelephonyManager tm = (TelephonyManager) TQLuaAndroidConsole.getApplicationInstance().getSystemService(Context.TELEPHONY_SERVICE);
				netName = tm.getNetworkOperatorName();
			}
			if (netName == null) {
				return "";
			}
			return netName;
		} catch (Exception e) {
			return "";
		}
	}

	/**
	 * 得到手机号
	 */
	public static String getNumber() {
		try {
			String number = null;
			TelephonyManager tm = (TelephonyManager) TQLuaAndroidConsole.getApplicationInstance().getSystemService(Context.TELEPHONY_SERVICE);
			number = tm.getLine1Number();
			if (number == null) {
				return "";
			}
			return number;
		} catch (Exception e) {
			return "";
		}
	}

	/**
	 * 获取当前客服电话
	 *
	 * @return
	 */
	public static String getServerPhone() {

		String servicePhone = "18210234002";
		// if (Const.ServerPhone.equals("")) {
		//
		// Const.ServerPhone = "18210234002";
		//
		// String servicePhone = "";
		// switch (getOperater()) {
		// case CHINA_MOBILE:
		// servicePhone =
		// TqLordConfigMessage.getInst().getHashMap(TqLordConfigMessage.MOBILE_SERVICE_PHONE);
		// break;
		// case CHINA_UNICOM:
		// servicePhone =
		// TqLordConfigMessage.getInst().getHashMap(TqLordConfigMessage.UNICOM_SERVICE_PHONE);
		// break;
		// case CHINA_TELECOM:
		// servicePhone =
		// TqLordConfigMessage.getInst().getHashMap(TqLordConfigMessage.TELECOM_SERVICE_PHONE);
		// break;
		// default:
		// servicePhone =
		// TqLordConfigMessage.getInst().getHashMap(TqLordConfigMessage.UNKNOWN_SERVICE_PHONE);
		// break;
		// }
		// String dayTime =
		// TqLordConfigMessage.getInst().getHashMap(TqLordConfigMessage.SERVICE_PHONE_DAY_TIME);
		// if (servicePhone != null && !servicePhone.equals("") && dayTime !=
		// null && !dayTime.equals("")) {
		// String[] data = servicePhone.split("\\n");
		// String[] time = dayTime.split("_");
		// if (data != null && time != null) {
		// Date curDate = new Date(System.currentTimeMillis() -
		// Const.TimeDifference);// 获取当前时间
		// int nowHour = Integer.parseInt(new
		// SimpleDateFormat("HH").format(curDate));
		// if (nowHour >= Integer.parseInt(time[0 % time.length]) && nowHour <
		// Integer.parseInt(time[1 % time.length])) {
		// // 白天
		// Const.ServerPhone = data[0 % data.length].replace("day:", "");
		// } else {
		// // 晚上
		// Const.ServerPhone = data[1 % data.length].replace("night:", "");
		// }
		// }
		// }
		// }
		return servicePhone;
	}

	/**
	 * 得到手机imei号
	 */
	public static String getImei() {
		try {
			String imei = null;
			TelephonyManager tm;
			tm = (TelephonyManager) TQLuaAndroidConsole.getApplicationInstance().getSystemService(Context.TELEPHONY_SERVICE);
			imei = tm.getDeviceId();
			if (imei == null) {
				return "";
			}
			return imei;
		} catch (Exception e) {
			return "";
		}
	}

	/**
	 * 获取设备中应用数据
	 *
	 * @param name
	 * @return
	 */
	public static PackageInfo getPkgInfoByName(String name) {
		PackageInfo packageInfo = null;
		try {
			packageInfo = TQLuaAndroidConsole.getApplicationInstance().getPackageManager().getPackageInfo(name, PackageManager.GET_ACTIVITIES);
		} catch (Exception e) {
		}

		return packageInfo;
	}

	// 渠道号
	private static int ChannelID = -1;

	// 获取渠道号
	public static int getChannelID() {
		if (ChannelID < 0) {
			String ID = "";
			try {
				ID = getJSONObjectFromAssets("apk_info.json").getString("ChannelID");
				ChannelID = Integer.parseInt(ID);
			} catch (Exception e) {
				e.printStackTrace();
				return 0;
			}
		}
		return ChannelID;
	}

	// 修改渠道号
	public static void setChannelID(int channelID) {
		ChannelID = channelID;
	}

	/**
	 * 得到版本号
	 *
	 * @return
	 */
	public static String getVersionName() {
		try {
			if (TQGameAndroidBridge.isLoadSDScript) {
				// 版本号在SD卡中
				return getScriptDataFromSD("scriptVerName");
			} else {
				// 版本号在Assets文件夹中
				return getScriptDataFromAssets("scriptVerName");
			}
		} catch (Exception e) {
			return "";
		}
	}

	/**
	 * 得到版本编号
	 *
	 * @return
	 */
	public static int getVersionCode() {
		try {
			if (TQGameAndroidBridge.isLoadSDScript) {
				// 版本号在SD卡中
				return getScriptVerCode(getScriptDataFromSD("scriptVerName")) + getChannelID();
			} else {
				// 版本号在Assets文件夹中
				return getScriptVerCode(getScriptDataFromAssets("scriptVerName")) + getChannelID();
			}
		} catch (Exception e) {
			return 0;
		}
	}

	/**
	 * 得到版本编号
	 *
	 * @return
	 */
	public static int getVersionCodeNoChannel() {
		try {
			if (TQGameAndroidBridge.isLoadSDScript) {
				// 版本号在SD卡中
				return getScriptVerCode(getScriptDataFromSD("scriptVerName"));
			} else {
				// 版本号在Assets文件夹中
				return getScriptVerCode(getScriptDataFromAssets("scriptVerName"));
			}
		} catch (Exception e) {
			return 0;
		}
	}

	/**
	 * 得到指定报名的应用版本编号
	 *
	 * @return
	 */
	public static int getVersionCodeForOtherApp(String packageName) {
		try {
			int nVer = TQLuaAndroidConsole.getApplicationInstance().getPackageManager().getPackageInfo(packageName, 0).versionCode;
			nVer = (nVer & 0xFFFFFF00);
			return nVer;
		} catch (Exception e) {
			Pub.LOG("getVersionCode " + e.getMessage());
			return 0;
		}
	}

	public static String getDeviceInfo() {
		String imei = "android_" + getImei() + "_" + getMacAddr();
		return imei;
	}

	/**
	 * 得到Mac地址
	 *
	 * @return
	 */
	public static String getMacAddr() {
		try {
			WifiManager wifi;
			wifi = (WifiManager) TQLuaAndroidConsole.getApplicationInstance().getSystemService(Context.WIFI_SERVICE);
			WifiInfo info = wifi.getConnectionInfo();
			return info.getMacAddress();
		} catch (Exception e) {
			Pub.LOG("getMacAddr " + e.getMessage());
			return "";
		}
	}

	private static String SAVE_PATH;

	public static String getSavePath() {
		if (SAVE_PATH != null) {
			return SAVE_PATH;
		}
		if (!Environment.getExternalStorageDirectory().canWrite()) {
			SAVE_PATH = TQLuaAndroidConsole.getApplicationInstance().getFilesDir().getAbsolutePath() + "/";
			// SAVE_PATH = "";
			return SAVE_PATH;
		}
		String sSavePath = Environment.getExternalStorageDirectory() + "/download/";
		File dir = new File(sSavePath);
		if (dir.exists()) {
			SAVE_PATH = sSavePath;
			return SAVE_PATH;
		}

		boolean b = dir.mkdirs();
		if (b) {
			SAVE_PATH = sSavePath;
			return SAVE_PATH;
		}
		SAVE_PATH = TQLuaAndroidConsole.getApplicationInstance().getFilesDir().getAbsolutePath() + "/";
		// SAVE_PATH = "";
		return SAVE_PATH;
	}

	private static ProgressDialog mProgressDialog;

	/**
	 * 显示Loading
	 *
	 * @param context
	 * @param sMsg
	 */
	public static void showProgressDialog(final String sMsg) {
		try {
			TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
				@Override
				public void run() {
					if (mProgressDialog != null && mProgressDialog.isShowing()) {
						mProgressDialog.dismiss();
					}
					mProgressDialog = new ProgressDialog(TQLuaAndroidConsole.getGameSceneInstance());
					mProgressDialog.setMessage(sMsg);
					mProgressDialog.show();
				}
			});
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 关闭Loading弹出框
	 */
	public static void closeProgressDialog() {
		try {
			TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
				@Override
				public void run() {
					if (mProgressDialog != null) {
						mProgressDialog.dismiss();
						mProgressDialog = null;
					}
				}
			});
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * loading是否还在显示中
	 *
	 * @return
	 */
	public static boolean isProgressDialogShowing() {
		if (mProgressDialog != null && mProgressDialog.isShowing()) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * 震动
	 */
	public static void vibrate() {
		Vibrator vibrator = (Vibrator) TQLuaAndroidConsole.getApplicationInstance().getSystemService(Context.VIBRATOR_SERVICE);
		vibrator.vibrate(200);
	}

	/**
	 * 获取SIM卡的ICCID
	 *
	 * @return
	 */
	public static String getICCID() {
		TelephonyManager tm = (TelephonyManager) TQLuaAndroidConsole.getApplicationInstance().getSystemService(Context.TELEPHONY_SERVICE);
		String ICCID = tm.getSimSerialNumber(); // 取出ICCID
		if (ICCID == null) {
			ICCID = "";
		}
		return ICCID;
	}

	/**
	 * 获取推荐人JSONObject里推荐ID的String回传给Lua
	 *
	 * @param context
	 * @return
	 */
	public static int getJSONObject() {
		JSONObject obj = null;
		try {
			InputStream is = TQLuaAndroidConsole.getGameSceneInstance().getAssets().open("apk_info.json");
			// InputStream is =
			// context.getResources().openRawResource(R.raw.apk_info);
			byte[] buffer;

			buffer = new byte[is.available()];

			is.read(buffer);

			String json = new String(buffer, "utf-8");

			obj = new JSONObject(json);

			int IntroducerID = Integer.parseInt(obj.getString("IntroducerID"));
			// TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() {
			// @Override
			// public void run() {
			// Cocos2dxLuaJavaBridge.callLuaFunctionWithString(callBack,
			// result);
			// Cocos2dxLuaJavaBridge.releaseLuaFunction(callBack);
			// }
			// });
			return IntroducerID;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return 0;
		}
	}
}
