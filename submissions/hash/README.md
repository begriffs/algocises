## Your challenge

Implement a hash table (using whatever internals you want,
although separate chaining might be easiest). Fill out these functions
and save the result to `src/hash/[your-github-name].js`.  Run the
test to see if you got it right. `node test/hash.js`. Once your
code passes send a pull request and add your solution to the freezer!

For best test coverage choose a small number of buckets to increase
the hash load factor. Each test round fills the table with between
ten and two hundred entries, so choosing a table size of one hundred
will exercise various scenarios of empty and full tables.

### Hash table template

```js
module.exports = function () {
  return self = {

    // Add value to the hash table, and
    // return the table. If t is null then
    // create a new table containing the value
    //
    // value will be a string
    insert: function (t, value) { },

    // Boolean. Does t contain value?
    find: function (t, value) { },

    // Return the table with value removed
    remove: function (t, value) { }

  };
};
```