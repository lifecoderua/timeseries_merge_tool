# Timeseries merge

## Given Requirements

Time series are stored in files with the following format:
- files are multiline plain text files in ASCII encoding
- each line contains exactly one record
- each record contains date and integer value; records are encoded like so: YYYY-­MM-­DD:X
- dates within single file are non­duplicate and sorted in ascending order
- files can be bigger than RAM available on target host

Create script which will merge arbitrary number of files, up to 100, into one file. Result file should follow same format
conventions as described above. Records with same date value should be merged into one by summing up Xvalues.

* We also have limitations which doesn't allow us to use third-party libraries for this task.

## Assumptions

- we expect low but reasonable amount of RAM, allowing us to store and manipulate with some reasonable amount of data (lets say hals a thousand records) in RAM;
- we expect all inputs to be valid and each file to has at least one entry
- we expect at least one input file to be provided
- we expect no years below zero

## Usage

```
# data run only 
ruby run.rb

# test run: regenerate input and compare with etalon file
ruby test.rb
```


### Implementation

- declare FileReader model to deal with a timeseries file;
- initialize an Array of FileReaders, one per input file;
- FileReader#init => reads the first entry; 
  - store century start (1800 for example);
  - set it as a start point (earliest century) for algorithm if this century is the lowest among other FileReaders
- iterate from the start point (earliest century occured in the input files) until the files are depleted:
  - iterate through FileReaders;
  - if the FileReader's century equals the workpoint:
    - read a bulk of entries;
    - parse CSV;
    - add to the current storage unless next century appeared;
    - repeat;
  - increase a century (or use next latest from FileReaders) 

### To Check
- make sure results are ordered;
- make sure over-century works correct;
- make sure results append correctly;
