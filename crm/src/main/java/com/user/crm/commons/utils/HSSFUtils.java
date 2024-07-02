package com.user.crm.commons.utils;

/**
 * @ClassName HSSFUtils
 * @Description
 * @Author 14036
 * @Version: 1.0
 */

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 用于操作Excel文件的工具类
 */
public class HSSFUtils {

    public static String getCellValueForStr(HSSFCell cell) {
        //获取列中的数据
        String str = "";
        if (cell == null) {
            return str;
        }
        if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
            str = cell.getStringCellValue();
        } else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
            str = cell.getNumericCellValue() + "";
        } else if (cell.getCellType() == HSSFCell.CELL_TYPE_BOOLEAN) {
            str = cell.getBooleanCellValue() + "";
        } else if (cell.getCellType() == HSSFCell.CELL_TYPE_FORMULA) {
            str = cell.getCellFormula();
        } else {
            str = "";
        }
        return str;
    }

    public static String getCellValue(Cell cell) {
        String temp = "";
        if (cell == null) {
            return temp;
        }
        switch (cell.getCellType()) {
            case Cell.CELL_TYPE_STRING:
                return cell.getRichStringCellValue().getString();
            case Cell.CELL_TYPE_NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) {
                    Date date = cell.getDateCellValue();
                    DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    temp = df.format(date);
                } else {
                    return String.valueOf(cell.getNumericCellValue());
                }
            case Cell.CELL_TYPE_FORMULA:
                cell.setCellType(Cell.CELL_TYPE_STRING);
                return cell.getStringCellValue();

            default:
                return temp;
        }
    }
}
