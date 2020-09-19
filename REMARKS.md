## Remarks:

1. Naming throughout the task (classes/variables/fields)
2. Clearer tests. Add comments, constants, etc. to them
3. Optimize code. Remove unnecessary "else", "{}", etc.
4. Zeroing the Total_Amount in the first batch is bad. All calculation logic in a special class calculateTotalAmount.cls
5. Excessive public/global, use a private with getter and setter {get; set;}
6. Calling the first batch in a loop for each level of the hierarchy, and not once for all levels. This solves the problem with the limit on the heap size
