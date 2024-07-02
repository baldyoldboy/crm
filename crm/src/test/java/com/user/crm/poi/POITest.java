package com.user.crm.poi;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.junit.Test;

import java.io.FileOutputStream;
import java.io.OutputStream;

/**
 * 使用apache-poi生成excel文件
 *
 * @ClassName POITest
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
public class POITest {
    public static void main(String[] args) throws Exception {
        //创建HSSFWorkbook对象，对应一个excel文件
        HSSFWorkbook workbook = new HSSFWorkbook();
        //使用workbook创建一个HSSFSheet对象，对应workbook中的一页
        HSSFSheet sheet = workbook.createSheet("学生列表");
        //使用sheet创建HSSFRow对象，对应sheet中的一行
        HSSFRow row = sheet.createRow(0);//行号，从0开始，依次增加
        //使用row创建HSSFCell对象，对应row中的一列
        HSSFCell cell = row.createCell(0);//列号，从0开始，依次增加

        //生成HSSFCellStyle对象
        HSSFCellStyle style =workbook.createCellStyle();
        style.setAlignment(HorizontalAlignment.CENTER);

        cell.setCellValue("学号");
        //给列加样式
        cell.setCellStyle(style);
        cell = row.createCell(1);
        cell.setCellValue("姓名");
        //给列加样式
        cell.setCellStyle(style);
        cell = row.createCell(2);
        cell.setCellValue("年龄");
        //给列加样式
        cell.setCellStyle(style);

        for (int i = 1; i <= 10; i++) {
            row = sheet.createRow(i);
            cell = row.createCell(0);
            cell.setCellValue(100 + i);
            //给列加样式
            cell.setCellStyle(style);

            cell = row.createCell(1);
            cell.setCellValue("Name" + i);
            //给列加样式
            cell.setCellStyle(style);
            cell = row.createCell(2);
            cell.setCellValue(20 + i);
            //给列加样式
            cell.setCellStyle(style);
        }

        //使用工具函数生成excel文件
        OutputStream os = new FileOutputStream("D:\\Users\\studentList.xls");
        workbook.write(os);

        //关闭资源
        os.close();
        workbook.close();
        System.out.println("===========create ok==========");
    }

}
