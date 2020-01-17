# TF-IDF

### Intuition
- Term frequency: Words you use a lot are important to you
- Inverse document frequency: Words used a lot across individuals does not differentiate you


### TF-IDF
Universal definition: tfidf = tf * idf

Popular definitions
- tf = term frequency from Bag of Words
- idf = log( N / (1 + n_d(t)) )
  - N = number of documents
  - n_d(t) = number of documents with the term

[Wikipedia provides many possible definitions for each term](https://en.wikipedia.org/wiki/Tf%E2%80%93idf). This is where your creativity can come in!

### Constructing TFIDF from arrays
- Recycle our pandas data frame named `bow` from before
- Use [Numpy broadcasting](https://docs.scipy.org/doc/numpy/user/basics.broadcasting.html) to do the multiplication

```
tf = bow.values
N = bow.shape[0]
idf_df = bow.apply(
  lambda x: pd.np.log(N / (1 + sum(x > 0))), axis=0)
# Manipulate the shape for broadcasting
idf = idf_df.values.reshape((1, -1))
tfidf = pd.DataFrame(tf * idf, columns=bow.columns)
```


### Let's try the built-in version from sklearn
```
from sklearn.feature_extraction.text import TfidfVectorizer

tfidf_vectorizer = TfidfVectorizer(analyzer=stem_analyzer)
tfidf_skl = tfidf_vectorizer.fit_transform(indeed['job_descriptions'])
tfidf_mat = tfidf_skl.toarray()
tokens = tfidf_vectorizer.get_feature_names()
```

Do you spot any difference between the 2 approaches?

### `TfidfVectorizer()` leverages `CountVectorizer()` and has addition features

- `TfidfVectorizer()` uses all the defaults from `CountVectorizer()` so we would have to modify the function similarly, i.e. `analyzer=stem_analyzer`
- `TfidfVectorizer()` also uses a "smoother" IDF definition
`log( (1+ N) / (1 + n_d(t)) ) + 1`
- `TfidfVectorizer()` also normalizes the row such that its L2 norm is 1, i.e. sum(x^2) = 1.

### Exercise
- Try modifying the broadcasting approach to replicate the outcome from `TfidfVectorizer()`
- To sort the columns, you can use `pandas.DataFrame.sort_index(axis=1, inplace=True)`

### The TF-IDF values are a normalized version of the data
Usecases:
- Used to extract important words, e.g. extracting the top 500 tokens sorted by their median TF-IDF value.
- Used as an input matrix for supervised learning if you have some labels for each document.
- Used as an input to calculate distance between documents

### Putting it all together
- Try out a [larger dataset](https://drive.google.com/file/d/1DV5PXPRGl6THkOPQBeX2iFwf0_MIExeC/view?usp=sharing)
- Find the top 50 words sorted by their average TF-IDF values
  - Try something besides the average, discuss with your partner which result you like more
