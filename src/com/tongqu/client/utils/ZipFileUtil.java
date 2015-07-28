package com.tongqu.client.utils;

import java.io.File;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

public class ZipFileUtil {

	public static HashMap<String, String> unzipingFiles = new HashMap<String, String>();// 存储正在处理的zip包
	public static HashMap<String, String> unzipFiles = new HashMap<String, String>();// 存储处理过的zip包

	/**
	 * zip解压后的文件是否可以使用
	 *
	 * @param zipFilePath
	 *            zip路径
	 * @return
	 */
	public static boolean isCanAccessZip(String zipFilePath) {
		boolean access = false;
		if (unzipFiles.get(zipFilePath) != null) {
			if (unzipFiles.get(zipFilePath).equals("true")) {
				access = true;
			}
		}
		return access;
	}

	/**
	 * 校验解压后文件完整性（是都解压完全，解压后的文件大小是否一致）
	 *
	 * @param dir
	 *            解压到的详细路径
	 * @param zipFilePath
	 *            zip文件详细路径
	 * @return
	 */
	public static void verifyUnZipedFiles(String dir, String zipFilePath) {
		if (unzipFiles.get(zipFilePath) != null || unzipingFiles.get(zipFilePath) != null) {
			return;
		}
		unzipingFiles.put(zipFilePath, dir);
		final String fDir = dir;
		final String fZipFilePath = zipFilePath;
		new Thread() {
			public void run() {
				File file = new File(fZipFilePath);// path是压缩文件路径
				if (!file.exists()) {
					unzipingFiles.remove(fZipFilePath);
					return;
				}
				try {
					ZipFile zipFile = new ZipFile(file);
					for (Enumeration<? extends ZipEntry> zipEntries = zipFile.entries(); zipEntries.hasMoreElements();) {// 遍历压缩文件中所有的子文件
						ZipEntry entry = (ZipEntry) zipEntries.nextElement();
						String zipEntryName = entry.getName();// 获取子文件的名字
						String realPath = fDir + File.separator + zipEntryName;
						if (Pub.isPics(realPath)) {
							realPath += "_data";
						} else if (Pub.isMusic(realPath)) {
							realPath += "_data";
						}
						File realFile = new File(realPath);
						boolean exist = realFile.exists();
						long realSize = 0;
						if (!exist) {
							// 不存在的话从新解压
							Pub.unZip(fZipFilePath, fDir);
							unzipingFiles.remove(fZipFilePath);
							return;
						}
						// 不是文件夹的话校验文件大小
						if (!realFile.isDirectory()) {
							realSize = realFile.length();
							if (realSize != entry.getSize()) {
								// 文件大小不相等从新解压
								Pub.unZip(fZipFilePath, fDir);
								unzipingFiles.remove(fZipFilePath);
								return;
							}
						}
					}
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					unzipingFiles.remove(fZipFilePath);
					return;
				}
				unzipFiles.put(fZipFilePath, "true");
				unzipingFiles.remove(fZipFilePath);
			};
		}.start();
	}

	/**
	 * 建立存储目录
	 */
	public static void createDirectory(File storageDirectory) {
		if (!storageDirectory.exists()) {
			storageDirectory.mkdirs();
		}
	}
}
