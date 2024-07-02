package com.user.crm.commons.utils;

import java.util.UUID;

public class FileNameUtil {
	//根据UUID生成文件名
	public static String getUUIDFileName() {
		UUID uuid = UUID.randomUUID();
		return uuid.toString().replace("-", "");
	}

	//根据给定的文件名和后缀截取文件名 包含.
	public static String getFileType(String fileName){
		//9527s.jpg
		int index = fileName.lastIndexOf(".");
		return fileName.substring(index);
	}
}
