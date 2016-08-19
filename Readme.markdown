Spreadsheet for iOS
==================

The goal of this problem is to create a simple spreadsheet app that is capable of loading a single spreadsheet and saving data into it. Please use the attached wireframe to design your UI.

Your app should allow the user to :
- Open a single spreadsheet
- Render that spreadsheet
- Save edits into that spreadsheet
- Allow an “undo” functionality that steps back through each change made on different cells; just like the undo function on Excel. [Bottom right of the image]
- Touching the cell should allow you to edit the cell’s content in the “Edit cell” editText as seen in the diagram
- The sheet should be able to accept any printable ASCII character. 
- The spreadsheet should be scrollable just like Excel.
- “Reload” functionality to reload the last saved content in the sheet. Any changes not saved will be removed on tapping reload
- At least two unit tests for any functionality

Please feel free to model the data in any way you like. The app must be capable of retrieving the saved data after it is relaunched.

You are free to use any model to save the data. We have given you an example model if you wish to use that. The data format is simply a two-dimensional array containing the values to be loaded in each cell. For example, the following serialized string:

'[[1], [2, 3], [4, 5, 6], [], [7, 8, 9, 0]]'

would represent the following table:

-------------------------------
| 1 | | | | |
-------------------------------
| 2 | 3 | | | |
-------------------------------
| 4 | 5 | 6 | | |
-------------------------------
| | | | | |
-------------------------------
| 7 | 8 | 9 | 0 | |
-------------------------------
| | | | | |
-------------------------------

Your spreadsheet should support a minimum of 8 rows and 8 columns.


Other Features
==============
If you have extra time, please attempt to implement the following features:

- Formula cells, 
* Similar to Excel: if you enter "=A1+B2*4" it should fill in the cell the computed value. (i.e. addition and subtraction).
- “Clear” functionality to clear out all at the cells in the row or column.
- Buttons to add rows and columns
- Warn the user that they might lose unsaved changes
