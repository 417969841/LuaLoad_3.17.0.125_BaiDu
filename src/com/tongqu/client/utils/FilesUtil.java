package com.tongqu.client.utils;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import android.content.Context;

import com.tongqu.client.config.GameConfig;
import com.tongqu.client.entity.User;
import com.tongqu.client.game.TQLuaAndroidConsole;
import com.tongqu.client.game.TqBroadCast;

/**
 * 持久化
 *
 */
public class FilesUtil {
	static FilesUtil filesUtil;

	public static String UpdataAppTime = "UpdataAppTime.data";// 碎片商城列表数据

	public FileOutputStream fos;
	public DataOutputStream dataOut;
	public DataInputStream dataIn;
	public FileInputStream fis;
	public static String USER_MSG;
	public static String ReloadResDataName;

	public static final char EncryptionKey = 23 + 't' + 'q';// 加密的key值

	public FilesUtil(Context context) {
		USER_MSG = Pub.getSaveFilePath() + "LordUser.dat";
		ReloadResDataName = Pub.getSaveFilePath() + GameConfig.APP_NAME + "reloadresData.dat";
	}

	public static FilesUtil getInstance() {
		if (filesUtil == null) {
			filesUtil = new FilesUtil(TQLuaAndroidConsole.getApplicationInstance());
		}
		return filesUtil;
	}

	/**
	 * 从SD卡上读取最后登录成功的用户信息
	 *
	 * @param name
	 * @return
	 */
	public User readUserMsg() {
		User user = null;
		try {
			if (fileSDOpen(READ, USER_MSG)) {
				user = new User();
				user.nickname = "" + encryption(dataIn.readUTF());
				user.password = "" + encryption(dataIn.readUTF());
				String userid = "" + encryption(dataIn.readUTF());
				user.userid = Integer.parseInt(userid);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			fileClose();
		}
		return user;
	}

	/**
	 * 存储最后登录成功的用户信息到SD卡上
	 *
	 * @param nickname
	 * @param password
	 */
	public void writeUserMsg(String nickname, String password, String userID) {
		try {
			Pub.LOG("nickname ======= " + nickname);
			Pub.LOG("password ======= " + password);
			Pub.LOG("userID ======= " + userID);
			User userFromSD = readUserMsg();
			if (userFromSD != null && userFromSD.nickname != null && userFromSD.password != null) {
				if (userFromSD.nickname.equals(nickname) && userFromSD.password.equals(password) && userFromSD.userid == Integer.parseInt(userID)) {
					return;
				}
			}
			if (fileSDOpen(WRITE, USER_MSG)) {
				dataOut.writeUTF("" + encryption(nickname));
				dataOut.writeUTF("" + encryption(password));
				dataOut.writeUTF("" + encryption(userID));
			}
			TqBroadCast.sendUserInfoBroadcast(TQLuaAndroidConsole.getApplicationInstance(), Integer.parseInt(userID), nickname, password, 0);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			fileClose();
		}
	}

	/**
	 * 位运算加密/解密
	 *
	 * @param obj
	 * @return
	 */
	public Object encryption(Object obj) {
		char[] array = ((String) obj).toCharArray();// 获取字符数组
		for (int w = 0; w < array.length; w++) {// 遍历字符数组
			array[w] = (char) (array[w] ^ EncryptionKey);// 对每个数组元素进行异或运算
		}
		return new String(array);
	}

	public static final int WRITE = 0;// 存储
	public static final int READ = 1;// 读取

	/**
	 *
	 * @param type0存储
	 *            1读取
	 */
	public boolean fileSDOpen(int type, String name) {
		boolean isCan = true;
		try {
			switch (type) {
			case WRITE:// 存储
				File dir = new File(Pub.getSaveFilePath());
				if (!dir.exists()) {
					dir.mkdirs();
				}
				File file = new File(name);
				if (!file.canWrite()) {
					file.createNewFile();
				}
				fos = new FileOutputStream(file);
				if (fos != null) {
					dataOut = new DataOutputStream(fos);
				} else {
					isCan = false;
				}
				break;
			case READ:// 读取
				file = new File(name);
				if (!file.canRead()) {
					isCan = false;
				}
				fis = new FileInputStream(file);
				if (fis != null) {
					dataIn = new DataInputStream(fis);
				} else {
					isCan = false;
				}
				break;
			}
		} catch (Exception e) {
			isCan = false;
		}
		return isCan;
	}

	/**
	 *
	 * @param type0存储
	 *            1读取
	 */
	public boolean fileOpen(int type, String name) {
		boolean isCan = true;
		try {
			switch (type) {
			case WRITE:// 存储
				fos = TQLuaAndroidConsole.getApplicationInstance().openFileOutput(name, Context.MODE_PRIVATE);
				if (fos != null) {
					dataOut = new DataOutputStream(fos);
				} else {
					isCan = false;
				}
				break;
			case READ:// 读取
				fis = TQLuaAndroidConsole.getApplicationInstance().openFileInput(name);
				if (fis != null) {
					dataIn = new DataInputStream(fis);
				} else {
					isCan = false;
				}
				break;
			}
			return isCan;
		} catch (Exception e) {
			return false;
		}
	}

	/**
	 * 关闭流接口
	 */
	public void fileClose() {
		try {
			if (dataOut != null) {
				dataOut.close();
			}
			if (fos != null) {
				fos.close();
			}
			if (fis != null) {
				fis.close();
			}
			if (dataIn != null) {
				dataIn.close();
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
