package com.user.crm.poi;

import com.user.crm.commons.utils.HSSFUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;

/**
 * 使用apache-poi解析excel文件
 *
 * @ClassName parseExcel
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
public class parseExcel {
    public static void main(String[] args) throws Exception {
        //根据excel文件生成HSSFWorkbook对象，封装了excel文件所有的信息
        InputStream is = new FileInputStream("D:\\Users\\activityList.xls");
        HSSFWorkbook workbook = new HSSFWorkbook(is);
        //根据workbook获取HSSFSheet对象，封装了一页的所有的信息
        HSSFSheet sheet = workbook.getSheetAt(0);//页的下标，下标从0开始，依次增加
        //根据sheet获取HSSFRow对象，封装了一行的所有信息
        HSSFRow row = null;
        HSSFCell cell = null;
        for (int i = 0; i <= sheet.getLastRowNum(); i++) {//sheet.getLastRowNum()：最后一行的下标
            row = sheet.getRow(i);//行的下标，从0开始

            for (int j = 0; j < row.getLastCellNum(); j++) {//row.getLastCellNum():最后一列的下标+1
                //根据row获取HSSFCell对象，封装了一列的信息
                cell = row.getCell(j);

                System.out.print(HSSFUtils.getCellValue(cell)+" ");

            }
            System.out.println();
        }

    }

}
