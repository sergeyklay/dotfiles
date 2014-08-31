// Pretty print in MongoDB shell as default
DBQuery.prototype._prettyShell = true;

// Output without pretty print
DBQuery.prototype.ugly = function() {
  this._prettyShell = false;
  
  return this;
}
