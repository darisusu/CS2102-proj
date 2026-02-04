import csv

"""
Simple I/O Library
  We assume all files are in UTF-8
"""
# Text
def read_text(file):
  """
  Read a file as text.  The name of the file is
  given as `file`.  The file is treated as utf-8
  format.

  The return type is a String.
  """
  with open(file, encoding='utf-8') as f:
    return f.read()
  return ''
def write_text(file, data):
  """
  Write the data into a file as text.  The name
  of the file is given as `file`.  The data is
  given as `data`.  The file is treated as utf-8
  format.

  There is no return value.
  """
  with open(file, 'w', encoding='utf-8') as f:
    f.write(data)

# CSV
def read_csv(file):
  """
  Read a file as comma-separated value (csv).
  The name of the file is given as `file`.  The
  file is treated as utf-8 format.

  The return type is a list-of-list.
  """
  res = []
  with open(file, encoding='utf-8') as f:
    rd = csv.reader(f)
    for row in rd:
      res.append(row)
  return res
def write_csv(file, data):
  """
  Write the data into a file as a comma-separated
  value (csv).  The name of the file is given as
  `file`.  The data is given as `data`.  The file
  is treated as utf-8 format.  The data is treated
  as a list-of-list.

  There is no return value.
  """
  with open(file, 'w', encoding='utf-8') as f:
    wt = csv.write(f, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    for row in data:
      wt.writerow(row)




"""
Helper functions
"""
def as_str(v):
  """
  Return the value as a string that can be
  accepted by postgresql as string.
  """
  s = f'{v}'.replace("'", "''")
  return f"'{s}'"
def as_int(v):
  """
  Return the value as a string that can be
  accepted by postgresql as integer.
  """
  return f'{v}'




"""
EXAMPLE
  Study the following example on how to process
  the csv file and write a file containing the
  INSERT statements.
"""
def process(file, out):
  # reading the data
  data = read_csv(file)[1:]

  # the expected output
  line = ''

  # process line by line
  for bib,stage,reason in data:
    # produce an INSERT statement given a row
    line += f'INSERT INTO some_table VALUES ({as_int(bib)}, {as_int(stage)}, {as_str(reason)});\n'

  # write into a file
  write_text(out, line)



# Change the input filename and/or the output filename
process('tdf-exits.csv', 'P01-data.sql')
