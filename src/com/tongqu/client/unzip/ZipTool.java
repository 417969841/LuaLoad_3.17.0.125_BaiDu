package com.tongqu.client.unzip;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Enumeration;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;

/**
 * 此工具类可提供压缩与解压缩功能
 */
public class ZipTool {
	// 输入解压文件路径为空
	public static int NULL_ZIPPATH = 0;

	// 解压文件不存在
	public static int NOTEXIST_ZIPFILE = 1;

	// 输入的解压路径已经存在
	public static int EXIST_UNZIPFILE = 2;

	// 操作成功
	public static int ZIPOPTION_SUCCESS = 3;

	// 输入的压缩文件已经存在于该路径中
	public static int EXIST_ZIPFILE = 4;

	// 操作失败
	public static int ZIPOPTION_FAIL = 5;

	/**
	 * <pre>
	 * 解压ZIP文件
	 * </pre>
	 *
	 * @param zipFilePath
	 *            String 需要解压的文件路径
	 * @param unzipPath
	 *            String 需要解压该文件到哪个路径
	 * @param charset
	 *            文件编码
	 * @return 解压结果的状态
	 */
	public static int unzip(String zipFilePath, String unzipPath, UnzipCallBack callBack) {
		if (null == zipFilePath || "".equals(zipFilePath.trim())) {
			return NULL_ZIPPATH;
		}

		// 需要解压到的目录已经存在时,返回目录已经存在的状态.否则创建目录
		File dirFile = new File(unzipPath);
		if (!dirFile.exists()) {
			dirFile.mkdirs();
		}

		// 没有输入字符集时,默认使用UTF-8
		// charset = null == charset ? StandardCharsets.UTF_8 : charset;

		// 需要解压的文件不存在时返回解压文件不存在的状态
		File file = new File(zipFilePath);
		if (!file.exists()) {
			return NOTEXIST_ZIPFILE;
		}

		ZipFile zipFile = null;
		try {
			zipFile = new ZipFile(file);
		} catch (IOException e) {
			e.printStackTrace();
			return ZIPOPTION_FAIL;
		}

		// 获取压缩包中的所有条目
		Enumeration<? extends ZipEntry> entries = zipFile.entries();
		int max = zipFile.size();
		ZipEntry entry = null;
		String unzipAbpath = dirFile.getAbsolutePath();
		int progress = 0;
		// 遍历条目,并读取条目流输出到文件流中(即开始解压)
		while (entries.hasMoreElements()) {
			entry = entries.nextElement();
			unzipEachFile(zipFile, entry, unzipAbpath);
			progress++;
			callBack.run(max, progress);
		}

		return ZIPOPTION_SUCCESS;
	}

	/**
	 * 对某一条目进行解压
	 *
	 * @param zipFile
	 *            ZipFile 需要解压的文件
	 * @param entry
	 *            ZipEntry 压缩文件中的条目
	 * @param unzipAbpath
	 *            String 解压文件的绝对路径
	 */
	private static void unzipEachFile(ZipFile zipFile, ZipEntry entry, String unzipAbpath) {
		byte[] buffer = new byte[1024];
		int readSize = 0;
		String name = entry.getName();
		String fileName = name;
		int index = 0;
		String tempDir = "";

		// 如果条目为目录,则在解压文件路径中创建此目录
		if (entry.isDirectory()) {
			File tempFile = new File(unzipAbpath + File.separator + name);
			if (!tempFile.exists()) {
				tempFile.mkdirs();
			}

			return;
		}

		// 不是目录时,由于压缩文件中目录里的文件名为:DIR/DIR/xxxFILE,所以可能文件前的目录并不存在于解压目录中,也需要创建
		if ((index = name.lastIndexOf(File.separator)) != -1) {
			fileName = name.substring(index, name.length());
			tempDir = name.substring(0, index);
			File tempDirFile = new File(unzipAbpath + File.separator + tempDir);
			if (!tempDirFile.exists()) {
				tempDirFile.mkdirs();
			}
		}

		// 使用输入输出流把条目读出并写到解压目录中
		String zipPath = unzipAbpath + File.separator + tempDir + fileName;
		File tempFile = new File(zipPath);
		InputStream is = null;
		FileOutputStream fos = null;
		try {
			is = zipFile.getInputStream(entry);
			if (!tempFile.exists()) {
				tempFile.createNewFile();
			}

			fos = new FileOutputStream(tempFile);
			while ((readSize = is.read(buffer)) > 0) {
				fos.write(buffer, 0, readSize);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (is != null) {
					is.close();
					is = null;
				}
				if (fos != null) {
					fos.close();
					fos = null;
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

	}

	/**
	 * 压缩文件方法,可以压缩多个文件或者目录
	 *
	 * @param newZipPath
	 *            String 生成压缩文件的路径
	 * @param wantZipPaths
	 *            String[] 需要压缩的文件条目
	 */
	public static int zip(String newZipPath, String[] wantZipPaths) {
		// 生成压缩文件的路径已经存在时,返回文件已经存在的状态
		File file = new File(newZipPath);
		if (file.exists()) {
			return EXIST_ZIPFILE;
		}

		// 不存在时,创建用户输入的目录结构
		String filePath = file.getAbsolutePath();
		String basePath = filePath.substring(0, filePath.lastIndexOf(File.separator));
		File dirFile = new File(basePath);
		if (!dirFile.exists()) {
			dirFile.mkdirs();
		}

		ZipOutputStream zos = null;
		try {
			// 生成压缩文件
			if (!file.exists()) {
				file.createNewFile();
			}

			// 打开压缩文件输出流,准备把待压缩的文件写入
			FileOutputStream fos = new FileOutputStream(file);
			zos = new ZipOutputStream(fos);
			File tempFile = null;
			for (String zipPath : wantZipPaths) {
				tempFile = new File(zipPath);
				if (!tempFile.exists()) {
					continue;
				}

				// 进行压缩文件
				zipEachFile(zos, tempFile, "");
			}
		} catch (IOException ie) {
			return ZIPOPTION_FAIL;
		} finally {
			try {
				zos.close();
			} catch (IOException e) {
				e.printStackTrace();
				return ZIPOPTION_FAIL;
			}
		}

		return ZIPOPTION_SUCCESS;
	}

	/**
	 * 压缩某个文件或文件夹 压缩文件方法,可以压缩多个文件或者目录
	 *
	 * @param zos
	 *            ZipOutputStream 压缩文件的输出流
	 * @param zipFile
	 *            File 需要压缩的文件或文件夹
	 * @param baseDir
	 *            String 压缩文件夹中的递归路径,使用时直接传入空值即可
	 */
	private static void zipEachFile(ZipOutputStream zos, File zipFile, String baseDir) {
		ZipEntry entry = null;

		// 如果需要压缩的是一个目录,由扫描该目录下的文件,并递归调用本方法进行压缩处理
		if (zipFile.isDirectory()) {
			// 压缩文件中的递归路径,记录了压缩文件中的文件夹路径
			baseDir = baseDir + zipFile.getName() + File.separator;
			File[] tempFiles = zipFile.listFiles();
			for (File tempFile : tempFiles) {
				zipEachFile(zos, tempFile, baseDir);
			}
		}

		// 不是文件夹时,使用文件输入流和压缩文件输出流把文件写入压缩文件中
		else {
			FileInputStream fis = null;
			try {
				entry = new ZipEntry(baseDir + zipFile.getName());
				zos.putNextEntry(entry);
				fis = new FileInputStream(zipFile);
				byte[] buffer = new byte[1024];
				int readSize = 0;
				while ((readSize = fis.read(buffer)) > 0) {
					zos.write(buffer, 0, readSize);
				}
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				try {
					fis.close();
					zos.closeEntry();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}

}
