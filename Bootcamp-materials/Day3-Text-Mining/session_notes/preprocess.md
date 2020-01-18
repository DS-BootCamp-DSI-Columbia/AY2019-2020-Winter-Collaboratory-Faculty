# Pre-processing text

### Recap from the previous session
- Lower casing the text (but should we always do this?)
- There are still some limitations, e.g. `re.findall("[^\w]R[^\w]", "R is awesome")`
- Got some Python running on non-structured text

### Where we are heading - Bag of Words
One of the biggest surprises in text mining is that many use cases do not require us to preserve the ordering of words for the document.

Bag of Words

|Tokens|"a"|"am"|...|"zeus"|
|---|---|---|---|---|
|Document 1|4|10|...|0|
|Document 2|100|50|...|3|
|...|...|...|...|...|
|Document N|20|8|...|0|

First choice is how to breakup a document into "tokens", e.g. is `can't` 2 words or one word?

### Overall preprocessing choices
We will not cover all of them:
- Punctuation, e.g. "#" or "@" on Twitter
- Numbers, e.g. "Article I, Section 2, Clause 5: Impeachment"
- Lowercasing
- Stemming, e.g. "cats" vs "cat"
- Stopword removal, e.g. "that", "the", "a"
- n-gram inclusion, e.g. "national debt"
- infrequently used terms, e.g. "That's so fetch"

For more information please see [Denny and Spirling 2017](https://www.nyu.edu/projects/spirling/documents/preprocessing.pdf). We are ignoring the hard problem of pronouns for now.

### Tokenization
- Prep-step
  ```
  import nltk
  nltk.download('punkt')
  ```
- The NLTK recommended tokenizer:
  ```
  from nltk.tokenize import word_tokenize
  word_tokenize("Dr. Watson wouldn't agree.")
  ```

For more information, see [nltk.tokenize](https://www.nltk.org/api/nltk.tokenize.html)
### Specialized tokenizers have been developed
Random tweet I found online...
```
from nltk.tokenize import TweetTokenizer
tweet = "We need a translation from @JColtonCosplay #STAT."

word_tokenize(tweet)

tokenizer = TweetTokenizer()
tokenizer.tokenize(tweet)
```

### Stress test the new solution
```
tokens = word_tokenize("R is awesome")
"R" in tokens
```

### Practice
Let's use the same Indeed [job descriptions on Google Drive](https://drive.google.com/open?id=1BXEl8iEMFsRjuyaIDJLVdtBRPFplFriV)  and tokenize the **3rd** document.
```
import json
indeed = json.load(open("../data/job_descriptions/indeed_job_descs_data+scientist.json",
                        "r"))
jds = indeed['job_descriptions']
```

- Go over the results with a partner, any surprises?
  - How do you want links handled, e.g. `bit.ly/2q6U8dq`?
- Is tokenizing affected by uppercase/lowercase?

### Lemmatization and Stemming
Tokenizing does not handle the difference between "develop" and "developing".

```
from nltk.stem import WordNetLemmatizer, PorterStemmer

stemmer = PorterStemmer()
stemmer.stem("Developing")
stemmer.stem("developed")

lemmatizer = WordNetLemmatizer()
lemmatizer.lemmatize("is", pos="v")
lemmatizer.lemmatize("are", pos="v")
lemmatizer.lemmatize("cats")
```

- `PorterStemmer()` lowercases **some** text...
  ```
  stemmer.stem("At")
  ```
- Stress test these capabilities, i.e. come up with examples that will disappoint you.

For more information, see [nltk.stem](https://www.nltk.org/api/nltk.stem.html)


### In practice
- Lemmatization is more careful but is often more demanding to use.
  - Did you try capitalization?
- Stemming is rarely perfect
  ```
  stemmer.stem('data')
  stemmer.stem('datum')
  ```


### Counting the frequency of each token
Try focusing on the 3rd document first:
```
from collections import Counter
tokens = word_tokenize(jds[2])
stemmed_tokens = [stemmer.stem(token) for token in tokens]
token_cnt = Counter(stemmed_tokens)
len(token_cnt)
len(set(tokens))
```

- Try tokenizing all of the job descriptions!
- [Optional] What is the typical decrease in number of unique tokens from stemming?
- Discuss with your partner, how would you combine all of these job description into a Bag of Word (aka term frequency) matrix?
  - What steps are required? No need to actually implement this yet.

### Stop words
There are words like "a", "is", "of", etc that do not provide a lot of meaning to the document.
There are often different collections of stop words for people to use to remove before processing
the data.

```
from nltk.corpus import stopwords
en_sw = set(stopwords.words('english'))

tokens = word_tokenize(jds[2].lower())
stemmed_tokens = [stemmer.stem(token)
                  for token in tokens
                  if token not in en_sw]
token_cnt = Counter(stemmed_tokens)
len(token_cnt)
```
