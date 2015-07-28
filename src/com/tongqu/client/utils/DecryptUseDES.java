package com.tongqu.client.utils;

import java.security.SecureRandom;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;

public class DecryptUseDES {
	public static String getDecryptForDES(String encryptedDataStr, String keyValue) {
		Pub.LOG("encryptedDataStr ====== " + encryptedDataStr);
		String[] encryptedList = encryptedDataStr.split(",");
		byte[] encryptedData = new byte[encryptedList.length];
		for (int i = 0; i < encryptedList.length; i++) {
			Pub.LOG("encryptedList[i] ====== " + encryptedList[i]);
			encryptedData[i] =  (byte) Integer.parseInt(encryptedList[i]);
		}
		// 获取密匙数据
		byte rawKeyData[] = keyValue.getBytes();
		// 调用解密方法
		String num = "";
		try {
			num = decrypt(rawKeyData, encryptedData);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return num;
	}

	public static String getString(short[] an) {
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < an.length; i++) {
			sb.append((char) an[i]);
		}
		return sb.toString();
	}

	/**
	 * 加密方法
	 *
	 * @param rawKeyData
	 * @param str
	 * @return
	 */
	public static byte[] encrypt(byte rawKeyData[], String str) {
		try {
			// DES算法要求有一个可信任的随机数源
			SecureRandom sr = new SecureRandom();
			// 从原始密匙数据创建一个DESKeySpec对象
			DESKeySpec dks = new DESKeySpec(rawKeyData);
			// 创建一个密匙工厂，然后用它把DESKeySpec转换成一个SecretKey对象
			SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
			SecretKey key = keyFactory.generateSecret(dks);
			// Cipher对象实际完成加密操作
			Cipher cipher = Cipher.getInstance("DES");
			// 用密匙初始化Cipher对象
			cipher.init(Cipher.ENCRYPT_MODE, key, sr);
			// 现在，获取数据并加密
			byte data[] = str.getBytes();
			// 正式执行加密操作
			byte[] encryptedData = cipher.doFinal(data);
			return encryptedData;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * 解密方法
	 *
	 * @param rawKeyData
	 * @param encryptedData
	 * @return
	 */

	public static String decrypt(byte rawKeyData[], byte[] encryptedData) throws Exception {
		// DES算法要求有一个可信任的随机数源
		SecureRandom sr = new SecureRandom();
		// 从原始密匙数据创建一个DESKeySpec对象
		DESKeySpec dks = new DESKeySpec(rawKeyData);
		// 创建一个密匙工厂，然后用它把DESKeySpec对象转换成一个SecretKey对象
		SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
		SecretKey key = keyFactory.generateSecret(dks);
		// Cipher对象实际完成解密操作
		Cipher cipher = Cipher.getInstance("DES");
		// 用密匙初始化Cipher对象
		cipher.init(Cipher.DECRYPT_MODE, key, sr);
		// 正式执行解密操作
		byte decryptedData[] = cipher.doFinal(encryptedData);
		return new String(decryptedData);
	}
}
