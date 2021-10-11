import os
import win32com.client as win32com

xlApp = win32.Dispatch('Excel.Application')
xlApp.Visible = True

"""
    Create a New Excel Workbook 
"""
wb = xlApp.Workbook.Add()
wb.SaveAs(os.path.join(os.getcwd(), 'text.xlsx'))

ws_sheet1 = wb.Worksheets('Sheet1')
ws_sheet1.name
ws_sheet1.name = 'Sheet1'ws_sheet.name = 'Dummy Data Test'

"""
    Write data into the Excel sheet 
"""
# Cells(row index, columnindex) # row index, column index
ws_sheet1.Cells(5,"B".Value = "Cell B5")
ws_sheet1.Cells(5,"C".Value = "Cell C5")

# Range() #A1 A1:B5
ws_sheet1.Range('D5').Value = 'Cell D5'

#Clear Cells
ws_sheet1.Cell.ClearContents()

"""
    Write data into mutiple cells in the Excel sheet
"""
ws_sheet1.Range("A1:E5").Value = 'Hello, world!'

ws_sheet1.Range(
    ws_sheet1.Cells(1, 1),
    ws_sheet1.Cells(5, 5)
).Value = 'Hello'

"""
     Read data
"""

for i in range(1,6):
    print(ws_sheet1.Range(
        ws_sheet1.Cells(i,  1),
        ws_sheet1.Cells(i,5)
    ).Value)

wb.Close(False)