## Your challenge

Use the rolling hash function you created earlier to implement a
Rabin-Karp substring search. Fill out these functions and save the
result to `submissions/rabin-karp/[your-github-name].js`.  Run the
test to see if you got it right. `node test/rabin-karp.js`. Once
your code passes send a pull request and add your solution to the
freezer!

### Substring find template

```js
module.exports = function () {
  var H = require('../hash/[your-github-name].js')();

  return {

    // both arguments are strings
    find: function(needle, haystack) { }

  };
};
```