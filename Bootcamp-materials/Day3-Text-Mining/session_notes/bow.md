# Bag of Words

### Bag of words or term frequency matrix

|Tokens|"a"|"am"|...|"zeus"|
|---|---|---|---|---|
|Document 1|4|10|...|0|
|Document 2|100|50|...|3|
|...|...|...|...|...|
|Document N|20|8|...|0|

- Each row corresponds to a document
- Each column represents a token

### Using `pandas.DataFrame()` to create the Bag of Words matrix
Assuming your previous exercise worked with `Counter()`, then
`pandas.DataFrame()` should work nicely.

For now, let's create the bag of words matrix

```
import json
from collections import Counter

import pandas as pd
from nltk.tokenize import word_tokenize
from nltk.stem import PorterStemmer
from nltk.corpus import stopwords

en_sw = set(stopwords.words('english'))
stemmer = PorterStemmer()
indeed = json.load(open("../data/job_descriptions/indeed_job_descs_data+scientist.json",
                        "r"))
tok_cnts = []
for jd in indeed["job_descriptions"]:
    tokens = word_tokenize(jd.lower())
    tokens = [stemmer.stem(token) for token in tokens if token not in en_sw]
    tok_cnts.append(Counter(tokens))

bow = pd.DataFrame(tok_cnts)
```

- What is the dimension of bow and what do they represent?
- How should we handle the NA values?
  - use `pandas.DataFrame.fillna()` to handle these


### scikit-learn has a package that makes Bag of Words for us
[CountVectorizer](https://scikit-learn.org/stable/modules/generated/sklearn.feature_extraction.text.CountVectorizer.html)

```
from sklearn.feature_extraction.text import CountVectorizer

vectorizer = CountVectorizer()
bow_skl = vectorizer.fit_transform(indeed['job_descriptions'])

tokens_skl = vectorizer.get_feature_names()
freq_skl = bow_skl.toarray()
```

- What is the dimension of the frequency matrix?
  - Is "r" among the words from `CountVectorizer()`?

### Scikit-Learn packages do a lot for you
- `CountVectorizer()` does not stem by default
- `CountVectorizer()` lowercases by default
- By default, tokens are "2 or more alphanumeric characters (punctuation is completely ignored and always treated as a token separator)". [Source.](https://github.com/scikit-learn/scikit-learn/blob/b194674c4/sklearn/feature_extraction/text.py#L636)

### Aligning `CountVectorizer()` with our output
```
vectorizer = CountVectorizer(stop_words=en_sw, tokenizer=word_tokenize)
analyzer = vectorizer.build_analyzer()


def stem_analyzer(doc):
    return [stemmer.stem(w) for w in analyzer(doc)]


stem_vectorizer = CountVectorizer(analyzer=stem_analyzer)
bow_skl = stem_vectorizer.fit_transform(indeed["job_descriptions"])
freq_skl = bow_skl.toarray()
```
Notice the warning is not an error!
