package com.tongqu.client.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

import android.os.Environment;
import android.widget.Toast;

import com.tongqu.client.game.TQLuaAndroidConsole;

public class CppLogCatch {

	public static void getLog() {
		StringBuffer str = new StringBuffer("\n----------------------------func start---------------------------\n"); // 方法启动
		try {
			ArrayList<String> cmdLine = new ArrayList<String>(); // 设置命令 logcat
																	// -d 读取日志
			cmdLine.add("logcat");
			cmdLine.add("-d");
			cmdLine.add("DEBUG:I *:S");

			ArrayList<String> clearLog = new ArrayList<String>(); // 设置命令 logcat
																	// -c 清除日志
			clearLog.add("logcat");
			clearLog.add("-c");

			Process process = Runtime.getRuntime().exec(cmdLine.toArray(new String[cmdLine.size()])); // 捕获日志
			BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(process.getInputStream())); // 将捕获内容转换为BufferedReader

			String readStr = null;
			while ((readStr = bufferedReader.readLine()) != null) // 开始读取日志，每次读取一行
			{
				Runtime.getRuntime().exec(clearLog.toArray(new String[clearLog.size()])); // 清理日志....这里至关重要，不清理的话，任何操作都将产生新的日志，代码进入死循环，直到bufferreader满
				str.append(readStr).append("\n"); // 输出，在logcat中查看效果，也可以是其他操作，比如发送给服务器..
			}
			if (readStr == null) {
				str.append("-------is null--------\n");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		str.append("----------------------------func end---------------------------\n");
		saveTxt(str.toString());
	}

	private static boolean saveTxt(String content) {
		// sd卡检测
		String sdStatus = Environment.getExternalStorageState();
		if (!sdStatus.equals(Environment.MEDIA_MOUNTED)) {
			Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance().getContext(), "SD 卡不可用", Toast.LENGTH_SHORT).show();
			return false;
		}

		File dir = new File(Pub.getSaveFilePath());
		if (!dir.exists()) {
			dir.mkdirs();
		}
		File file = new File(Pub.getSaveFilePath() + File.separator + "cpp_error.txt");
		FileOutputStream outputStream = null;
		try {
			if (!file.canWrite()) {
				file.createNewFile();
			}
			// 创建文件，并写入内容
			outputStream = new FileOutputStream(file, true);
			String msg = new String(content);
			outputStream.write(msg.getBytes("UTF-8"));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			return false;
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (outputStream != null) {
				try {
					outputStream.flush();
				} catch (IOException e) {
					e.printStackTrace();
				}
				try {
					outputStream.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return true;
	}

}
