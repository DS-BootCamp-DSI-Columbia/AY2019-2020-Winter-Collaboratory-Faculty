# Basic String Manipulation and Regular Expression in Python

### Data Introduction - Job Descriptions
We have some Indeed [job descriptions on Google Drive](https://drive.google.com/open?id=1BXEl8iEMFsRjuyaIDJLVdtBRPFplFriV), download this to your desired working folder.

Load the data into your Jupyter Notebook workspace
```
import json
indeed = json.load(open("../data/job_descriptions/indeed_job_descs_data+scientist.json",
                        "r"))
```

### Python strings
Type each of the following into a different Jupyter Cell
```
jd_demo = indeed['job_descriptions'][0]
"Python" in jd_demo
"python" in jd_demo
"python" in jd_demo.lower()
```

R is also popular programming language, why might `"R" in jd_demo` not be a good idea?

### Regular expression helps us navigate within a document for validation
Find all occurrences of "python" and "R" in the document:
```
import re
re.findall('.{20}python.{20}', jd_demo.lower())
re.findall('.{20}R.{20}', jd_demo)
```

### Regular expression
There's the pattern then the frequency

**Patterns**

|Regular Expression| Meaning| Example|
|---|---|---|
|`.`|Wildcard, anything will be matched|`re.findall(".", "wtl2109@columbia.edu")`|
|`\w`|alphanumeric or the underscore "_"|`re.findall("\w", "indeed_jd_2020.json")`|
|`[0-9]`|Numerics|`re.findall("\w", "indeed_jd_2020.json")`|
|`[a-z]`|lower case alphabet|`re.findall("[a-z]", "Text Mining 101")`|
|`[A-Za-z]`|Upper and lower case alphabet|`re.findall("[A-Za-z]", "Text Mining 101")`|
|`[^a-z]`|NOT lower case alphabet|`re.findall("[^a-z]", "Text Mining 101")`|

**Frequencies**
- All patterns are assumed to occur exactly once if not specified
- The frequency specification only applied to the "pattern" just before the specification

|Regular Expression| Meaning| Example|
|---|---|---|
|`{2}`|Exactly twice|`re.findall("[a-z]{2}", "Vim is a cool tool")`|
|`{2,4}`|Exactly 2 to 4 times|`re.findall("[a-z]{2,4}", "o oo ooo oooo ooooo")`|
|`?`|Zero or one occurrence|`re.findall(" r ?", "r or r/python are reoccurring requirements")`|
|`+`|One or more occurrence|`re.findall("r+", "r or r/python are reoccurring requirements")`|
|`*`|Zero or more occurrence|`re.findall(" r[^\w]*", "r or r/python are reoccurring requirements")`|

There are far superior regular expression tutorials out there! Here we only rely on it to quickly identify the location within the text we need to target.

### Exercise
Let's apply this to our third document
```
re.findall('.{0,20}R.{0,20}', indeed['job_descriptions'][2])
```
- Work with a partner for the meaning behind the pattern `.{0,20}R.{0,20}`
  - Why did we change from `.{20}` to `.{0,20}`?
- How can we filter out the desired mentions of "R"?
  - Try it out on the third document

### Python Warm-up
The data structure:
```
{"job_descriptions": [
  "JOB DESC1",
  "JOB DESC2",
  "JOB DESC3",
  ...],
 "request_params": {
   "jt": "fulltime",
   "l": "New York State",
   ...
   }
 }
```

Try to answer the following:
- How many job descriptions are there in this dataset?
- What was the query used to get the data?
- How many job descriptions mention "python" or "R" respectively?
  - Don't try to be perfect here, we will explore this further
  - Hints:
    - write a loop then recycle your previous work!
      ```
      results = []
      for jd in indeed['job_descriptions']:
          results.append(YOUR_OUTPUT)

      results
      ```
    - what does `re.findall` output if there is no match?
